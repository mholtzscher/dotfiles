function aws_export_envs
    #export (aws configure export-credentials --profile $AWS_PROFILE --format env-no-export | string split \n)
    export (aws configure export-credentials --profile $AWS_PROFILE --format env-no-export )
end
