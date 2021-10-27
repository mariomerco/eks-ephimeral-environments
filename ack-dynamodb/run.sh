# Reference: https://aws-controllers-k8s.github.io/community/docs/user-docs/install/

export AWS_REGION=us-east-2
export HELM_EXPERIMENTAL_OCI=1
export ACK_K8S_NAMESPACE=ack-system
export SERVICE=dynamodb

kubectl create namespace ack-system

ACCOUNT_ID=`aws sts get-caller-identity --query "Account" --output text`

aws cloudformation deploy \
    --stack-name ${SERVICE}-controller-iam-policy \
    --template-file iam.json \
    --capabilities CAPABILITY_NAMED_IAM


eksctl create iamserviceaccount \
    --name ack-${SERVICE}-controller \
    --cluster my-eks-cluster \
    --namespace ${ACK_K8S_NAMESPACE} \
    --attach-policy-arn arn:aws:iam::${ACCOUNT_ID}:policy/DynamoDBControllerIamPolicy \
    --override-existing-serviceaccounts \
    --approve


export RELEASE_VERSION=`curl -sL https://api.github.com/repos/aws-controllers-k8s/${SERVICE}-controller/releases/latest | grep '"tag_name":' | cut -d'"' -f4`
export CHART_EXPORT_PATH=/tmp/chart
export CHART_REF=$SERVICE-chart
export CHART_REPO=public.ecr.aws/aws-controllers-k8s/$CHART_REF
export CHART_PACKAGE=$CHART_REF-$RELEASE_VERSION.tgz

mkdir -p $CHART_EXPORT_PATH

helm pull oci://$CHART_REPO --version $RELEASE_VERSION -d $CHART_EXPORT_PATH
tar xvf $CHART_EXPORT_PATH/$CHART_PACKAGE -C $CHART_EXPORT_PATH



helm upgrade --install \
    --namespace $ACK_K8S_NAMESPACE \
    --set aws.region="$AWS_REGION" \
    --set serviceAccount.create=false \
    --set aws.region=${AWS_REGION} \
    --set aws.account_id=${ACCOUNT_ID} \
    ack-$SERVICE-controller \
    $CHART_EXPORT_PATH/$SERVICE-chart

