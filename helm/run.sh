kubectl create namespace $1

helm upgrade --install \
    sample-app-$1 \
    --namespace $1 \
    .