function aws_export_envs --description "Export AWS credentials as environment variables"
    #export (aws configure export-credentials --profile $AWS_PROFILE --format env-no-export | string split \n)
    export (aws configure export-credentials --profile $AWS_PROFILE --format env-no-export )
end
