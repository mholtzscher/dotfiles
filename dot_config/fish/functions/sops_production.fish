function sops_staging --description "Run sops with the production profile"
    set -l AWS_PROFILE m3p_staging
    set -l SOPS_KMS_ARN "arn:aws:kms:us-west-2:533267267027:key/mrk-17f6bf15417942fd9237ed50d33363ca"

    command sops $argv
end
