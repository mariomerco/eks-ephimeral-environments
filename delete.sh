echo "Make sure you have deleted all the helm releases for the sample app"
helm ls --all-namespaces
read
kubectl delete -f external-dns/external-dns.yaml
helm delete --namespace kube-system aws-load-balancer-controller

eksctl delete cluster --name my-eks-cluster

aws cloudformation delete-stack --stack-name external-dns-iam-policy
aws cloudformation delete-stack --stack-name aws-load-balancer-controller-iam-policy