namespace=$1

if [ -z "${namespace}" ]
then
    echo "Missing the 'Namespace' parameter. Please run this command like './create.sh dev', where 'dev' is the namespace."
    exit 1
fi

ACCOUNT_ID=`aws sts get-caller-identity --query "Account" --output text`

eksctl create iamserviceaccount \
    --name services-api \
    --cluster my-eks-cluster \
    --namespace ${namespace} \
    --attach-policy-arn arn:aws:iam::${ACCOUNT_ID}:policy/ServicesIAMPolicy \
    --override-existing-serviceaccounts \
    --approve

helm upgrade --install --create-namespace --namespace ${namespace} services-api-${namespace} .