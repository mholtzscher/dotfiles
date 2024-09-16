function aws_ecr_login --description "Login to AWS ECR"
    aws ecr get-login-password | docker login --username AWS --password-stdin 188442536245.dkr.ecr.us-west-2.amazonaws.com
end
