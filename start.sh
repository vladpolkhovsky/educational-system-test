kubectl create secret tls local-selfsigned-tls --cert=tls.crt --key=tls.key --namespace traefik

helm repo add traefik https://traefik.github.io/charts
helm repo add collabora https://collaboraonline.github.io/online
helm install traefik traefik/traefik --namespace traefik --values .\traefik\values.yaml

kubectl create namespace traefik
kubectl create secret tls local-selfsigned-tls --cert=.\traefik\tls.crt --key=.\traefik\tls.key --namespace traefik

helm install traefik traefik/traefik --namespace traefik --values .\traefik\values.yaml
kubectl apply -f .\traefik\configmap.yaml
kubectl apply -f .\traefik\deployment.yaml

helm install --namespace traefik collabora-online collabora/collabora-online -f .\collabora\values.yaml
kubectl delete hpa collabora-online -n traefik --ignore-not-found=true