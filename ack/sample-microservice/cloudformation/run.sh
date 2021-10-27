aws cloudformation deploy \
    --stack-name services-api-policy \
    --template-file iam.json \
    --capabilities CAPABILITY_NAMED_IAM
