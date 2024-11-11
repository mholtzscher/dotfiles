
def fmt [] {
  ls | each { |v| 
    if ($v.name == "go.mod") {
      echo "go.mod found. Running Go formatter..."
      go fmt ./...
    } else if ($v.name == "build.gradle") {
      echo "build.gradle found. Running ./gradlew spotlessApply..."
      run-external "./gradlew" "spotlessApply" "--parallel"
      # ./gradlew spotlessApply --parallel
    } 
  }
}

def aws_change_profile [
    profile?: string # Optional profile argument
] {
    let profile = if ($profile | is-empty) {
        if (which fzf | is-empty) {
            print "fzf is not installed. Please install fzf to use this feature."
            exit 1
        }
        aws configure list-profiles | fzf
    } else {
        $profile
    }

    if ($profile | is-empty) {
        print "No profile selected"
        return
    }

    $env.AWS_PROFILE = $profile
    print $"Using AWS profile: ($env.AWS_PROFILE)"

    if (aws configure get sso_start_url --profile $env.AWS_PROFILE | complete | get exit_code ) == 0 {
        aws_sso_login
    } else {
      print "No SSO configuration found for profile: $env.AWS_PROFILE"
    }
}

def aws_sso_login [] {
  if (aws sts get-caller-identity | complete | get exit_code) == 0 {
      print "Logging into AWS"
      aws sso login
  } else {
      print "Found valid AWS session"
  }
}
