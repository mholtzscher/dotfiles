function aws_login --description 'Login to AWS SSO and set the AWS_PROFILE'
    set -l profile $argv[1]

    aws sso login --profile $profile
    set -gx AWS_PROFILE $profile
end
