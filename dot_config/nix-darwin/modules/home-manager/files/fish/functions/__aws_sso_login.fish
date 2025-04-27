if aws sts get-caller-identity >/dev/null 2>&1
    echo "Found valid AWS session"
else
    echo "Logging into AWS"
    aws sso login
end
