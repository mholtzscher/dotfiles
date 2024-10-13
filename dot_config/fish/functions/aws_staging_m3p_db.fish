function aws_staging_m3p_db --description "SSH tunnel to AWS staging database"
    ssh_tunnel ~/.ssh/staging_m3p.rsa 5433 m3p-staging.cluster-ro-cxa0kcuamo2t.us-west-2.rds.amazonaws.com:5432 ec2-user@44.226.111.43
end
