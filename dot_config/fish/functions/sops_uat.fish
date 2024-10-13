function sops_uat --description "Run sops with the uat profile"
    set -x AWS_PROFILE m3p_uat
    set -x SOPS_KMS_ARN "arn:aws:kms:us-west-2:590183679435:key/mrk-3c092342ff9a488399c0ffee8e89eb53"

    command sops $argv
end
