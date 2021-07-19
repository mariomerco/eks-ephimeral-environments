aws cloudformation deploy \
    --stack-name external-dns-iam-policy \
    --template-file iam.json \
    --capabilities CAPABILITY_NAMED_IAM


eksctl create iamserviceaccount \
    --name external-dns \
    --cluster my-eks-cluster \
    --namespace default \
    --attach-policy-arn arn:aws:iam::750796802028:policy/ExternalDNSPolicy \
    --override-existing-serviceaccounts \
    --approve

kubectl apply -f external-dns.yaml