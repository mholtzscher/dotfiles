
def fmt [] {
  ls | each { |v| 
    if ($v.name == "go.mod") {
      echo "go.mod found. Running Go formatter..."
      go fmt ./...
    } else if ($v.name == "build.gradle") {
      echo "build.gradle found. Running ./gradlew spotlessApply..."
      run-external "./gradlew" "spotlessApply" "--parallel"
      # ./gradlew spotlessApply --parallel
    } else {
      echo "no supported files found"
    }
  }
}

def aws_change_profile --env [
    profile?: string # Optional profile argument
] {
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
  if (aws sts get-caller-identity | complete | get exit_code) == 0 {
      print "Logging into AWS"
      aws sso login
  } else {
      print "Found valid AWS session"
  }
}

def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}
