
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

def aws_change_profile --env [ profile?: string ] {
    let profile = if ($profile | is-empty) {
        aws configure list-profiles | lines | input list
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
      print $"No SSO configuration found for profile: ($env.AWS_PROFILE)"
    }
}

def aws_sso_login [] {
  let result = aws sts get-caller-identity | complete 
  if (result | get exit_code) == 0 {
      print "Logging into AWS"
      aws sso login
  } else {
      print "Found valid AWS session"
  }
}

