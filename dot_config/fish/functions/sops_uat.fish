function sops_staging --description "Run sops with the uat profile"
    set -l AWS_PROFILE m3p_staging
    set -l SOPS_KMS_ARN "arn:aws:kms:us-west-2:211125772151:key/mrk-d167c0b6c99945fabfc4b629d52450ad"

    command sops $argv
end
