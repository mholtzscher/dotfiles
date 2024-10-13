function aws_uat_m3p_db --description "SSH tunnel to AWS uat database"
    ssh_tunnel ~/.ssh/uat_m3p.rsa 5433 m3p-uat.cluster-ro-cbm6meio8xhm.us-west-2.rds.amazonaws.com:5432 ec2-user@44.225.104.92
end
