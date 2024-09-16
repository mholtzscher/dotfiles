function awslocal --description 'Run AWS CLI commands against LocalStack'
    env AWS_PROFILE=localstack aws --endpoint-url=http://localhost.localstack.cloud:4566 $argv
end
