echo "Make sure you have deleted all the helm releases for the 'sample app' (ignore aws-load-balancer-controller release, this is deleted automatically by this script)"
helm ls --all-namespaces
echo "If all Helm are deleted, please press [ENTER], if not [CTRL+C] and do so"
echo "If the 'sample-app' and 'services-api' releases are not deleted, this won't delete load balancers, target groups, DynamoDB Tables, or Route53 records automatically."
read
kubectl delete -f external-dns/external-dns.yaml
helm delete --namespace kube-system aws-load-balancer-controller
helm delete --namespace ack-system ack-dynamodb-controller

eksctl delete iamserviceaccount --name external-dns --cluster my-eks-cluster
eksctl delete iamserviceaccount --name aws-load-balancer-controller --namespace kube-system --cluster my-eks-cluster
eksctl delete iamserviceaccount --name ack-dynamodb-controller --namespace ack-system --cluster my-eks-cluster

sleep 5

eksctl get iamserviceaccount --cluster my-eks-cluster
echo "If all IAM Roles for Service Accounts are deleted, please press [ENTER], if not [CTRL+C] and do so"
read

eksctl delete cluster --name my-eks-cluster

aws cloudformation delete-stack --stack-name external-dns-iam-policy
aws cloudformation delete-stack --stack-name aws-load-balancer-controller-iam-policy
aws cloudformation delete-stack --stack-name services-api-policy
aws cloudformation delete-stack --stack-name dynamodb-controller-iam-policy