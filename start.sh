helm repo add traefik https://traefik.github.io/charts
helm repo add collabora https://collaboraonline.github.io/online

kubectl create namespace traefik

# Create dummy TLS secret for Gateway (placeholder - will be replaced by Let's Encrypt)
kubectl create secret tls dummy-tls --cert=./traefik/tls.crt --key=./traefik/tls.key --namespace traefik || true

# Create ACME secret for Let's Encrypt certificates storage
kubectl create secret generic acme-json --from-file=acme.json=./traefik/acme.json --namespace traefik || true

helm install traefik traefik/traefik --namespace traefik --values ./traefik/values.yaml

kubectl apply -f ./mirotalk-p2p/configmap.yaml
kubectl apply -f ./mirotalk-p2p/deployment.yaml

helm install --namespace traefik collabora-online collabora/collabora-online -f ./collabora/values.yaml
kubectl delete hpa collabora-online -n traefik --ignore-not-found=true