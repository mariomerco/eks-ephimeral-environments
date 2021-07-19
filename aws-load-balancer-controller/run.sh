aws cloudformation deploy \
    --stack-name aws-load-balancer-controller-iam-policy \
    --template-file iam.json \
    --capabilities CAPABILITY_NAMED_IAM


eksctl create iamserviceaccount \
    --name aws-load-balancer-controller \
    --cluster my-eks-cluster \
    --namespace kube-system \
    --attach-policy-arn arn:aws:iam::750796802028:policy/AWSLoadBalancerControllerPolicy \
    --override-existing-serviceaccounts \
    --approve

helm repo add eks https://aws.github.io/eks-charts
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"
helm install aws-load-balancer-controller \
    eks/aws-load-balancer-controller \
    --namespace kube-system \
    --set clusterName=my-eks-cluster \
    --set serviceAccount.create=false \
    --set serviceAccount.name=aws-load-balancer-controller