#function aws_login --description 'Login to AWS SSO and set the AWS_PROFILE'
#    set -l profile $argv[1]
#
#    aws sso login --profile $profile
#    set -gx AWS_PROFILE $profile
#end

function aws_change_profile --description 'Change the AWS profile and login to SSO'
    set -gx AWS_PROFILE $argv[1]
    echo "Using AWS profile: $AWS_PROFILE"

    if aws configure get sso_start_url --profile $AWS_PROFILE >/dev/null 2>&1
        aws_sso_login
    end
end

function aws_sso_login --description 'Login to AWS SSO'
    if aws sts get-caller-identity >/dev/null 2>&1
        echo "Found valid AWS session"
    else
        echo "Logging into AWS"
        aws sso login
    end
end
