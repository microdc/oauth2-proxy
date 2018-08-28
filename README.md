# k8s-oauth2-proxy
Deploy [bitly/oauth2_proxy](https://github.com/bitly/oauth2_proxy) using docker and kubernetes


## Deploy on Kubernetes
Details on how to obtain the configuration options below are available [here](https://github.com/bitly/oauth2_proxy#google-auth-provider)

1. Run kubectl to create the deployment and apps Namespace. The containers wont run until the configs are created below.
```
kubectl apply -f k8s.yaml
```
2. Create a config map for the oauth2_proxy config items
```
cat > "oauth2_proxy_config" << EOF
EMAIL_DOMAIN=equalexperts.com
UPSTREAM=http://kibana.instrumentation:5602/
CLIENT_ID=101010101010-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com
EOF

kubectl create configmap oauth2-proxy-config -n apps --from-env-file=oauth2_proxy_config
```
3. Create secrets for oauth2_proxy. The 'Client Secret' provided in the
GoogleAPIs interface should be used for both COOKIE_SECRET and CLIENT_SECRET
below.
```
cat > oauth2-proxy-secret << EOF
COOKIE_SECRET=XXXXXXXXXXXXXXXXXXXXXXXXXXX
CLIENT_SECRET=XXXXXXXXXXXXXXXXXXXXXXXXXXX
EOF

kubectl create secret generic oauth2-proxy-secret -n apps \
                                         --from-env-file=oauth2-proxy-secret
```

### Configure the Ingress (kubernetes nginx)
```
export VHOST="oauth2_proxy.example.com"
kubectl apply -f <(envsubst < ingress.yaml.template)
```
