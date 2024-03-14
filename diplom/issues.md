```
vagrant@master:~$ kubectl get ingress
NAME      CLASS   HOSTS             ADDRESS   PORTS   AGE
example   nginx   www.example.com             80      48m

vagrant@master:~$ kubectl get svc -o wide
NAME                                 TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE    SELECTOR
ingress-nginx-controller             LoadBalancer   10.233.48.228   <pending>     80:31984/TCP,443:30244/TCP   54m    app.kubernetes.io/component=controller,app.kubernetes.io/instance=ingress-nginx,app.kubernetes.io/name=ingress-nginx
ingress-nginx-controller-admission   ClusterIP      10.233.6.121    <none>        443/TCP                      54m    app.kubernetes.io/component=controller,app.kubernetes.io/instance=ingress-nginx,app.kubernetes.io/name=ingress-nginx
kubernetes                           ClusterIP      10.233.0.1      <none>        443/TCP                      5h2m   <none>
my-service                           NodePort       10.233.50.233   <none>        80:30001/TCP                 131m   app=myapp

vagrant@master:~$ kubectl get pods
NAME                                        READY   STATUS    RESTARTS   AGE
ingress-nginx-controller-55474d95c5-7ngmn   1/1     Running   0          55m
my-deployment-75ddb8877c-kxhd8              1/1     Running   0          132m
my-deployment-75ddb8877c-lmsnp              1/1     Running   0          132m

vagrant@master:~$ kubectl logs  ingress-nginx-controller-55474d95c5-7ngmn
W0314 12:45:39.417228       7 client_config.go:618] Neither --kubeconfig nor --master was specified.  Using the inClusterConfig.  This might not work.
I0314 12:45:39.417445       7 main.go:205] "Creating API client" host="https://10.233.0.1:443"
-------------------------------------------------------------------------------
NGINX Ingress controller
  Release:       v1.10.0
  Build:         71f78d49f0a496c31d4c19f095469f3f23900f8a
  Repository:    https://github.com/kubernetes/ingress-nginx
  nginx version: nginx/1.25.3

-------------------------------------------------------------------------------

I0314 12:45:39.427054       7 main.go:249] "Running in Kubernetes cluster" major="1" minor="29" git="v1.29.2" state="clean" commit="4b8e819355d791d96b7e9d9efe4cbafae2311c88" platform="linux/amd64"
I0314 12:45:39.749836       7 main.go:101] "SSL fake certificate created" file="/etc/ingress-controller/ssl/default-fake-certificate.pem"
I0314 12:45:39.782139       7 ssl.go:536] "loading tls certificate" path="/usr/local/certificates/cert" key="/usr/local/certificates/key"
I0314 12:45:39.808960       7 nginx.go:265] "Starting NGINX Ingress controller"
I0314 12:45:40.014350       7 event.go:364] Event(v1.ObjectReference{Kind:"ConfigMap", Namespace:"default", Name:"ingress-nginx-controller", UID:"da43fa9b-e7f2-40d9-b06c-67b6994ef32b", APIVersion:"v1", ResourceVersion:"30438", FieldPath:""}): type: 'Normal' reason: 'CREATE' ConfigMap default/ingress-nginx-controller
I0314 12:45:41.112830       7 store.go:436] "Ignoring ingress because of error while validating ingress class" ingress="default/minimal-ingress" error="no object matching key \"nginx-example\" in local store"
I0314 12:45:41.210320       7 nginx.go:308] "Starting NGINX process"
I0314 12:45:41.210404       7 leaderelection.go:250] attempting to acquire leader lease default/ingress-nginx-leader...
I0314 12:45:41.210804       7 nginx.go:328] "Starting validation webhook" address=":8443" certPath="/usr/local/certificates/cert" keyPath="/usr/local/certificates/key"
I0314 12:45:41.211125       7 controller.go:190] "Configuration changes detected, backend reload required"
I0314 12:45:41.239486       7 leaderelection.go:260] successfully acquired lease default/ingress-nginx-leader
I0314 12:45:41.239792       7 status.go:84] "New leader elected" identity="ingress-nginx-controller-55474d95c5-7ngmn"
I0314 12:45:41.274971       7 controller.go:210] "Backend successfully reloaded"
I0314 12:45:41.275366       7 controller.go:221] "Initial sync, sleeping for 1 second"
I0314 12:45:41.276069       7 event.go:364] Event(v1.ObjectReference{Kind:"Pod", Namespace:"default", Name:"ingress-nginx-controller-55474d95c5-7ngmn", UID:"125656cb-c1f0-4037-bd2d-185a64a0ea2b", APIVersion:"v1", ResourceVersion:"30479", FieldPath:""}): type: 'Normal' reason: 'RELOAD' NGINX reload triggered due to a change in configuration
W0314 12:51:03.070227       7 controller.go:1108] Error obtaining Endpoints for Service "default/exampleservice": no object matching key "default/exampleservice" in local store
I0314 12:51:03.091480       7 main.go:107] "successfully validated configuration, accepting" ingress="default/example"
I0314 12:51:03.101220       7 store.go:440] "Found valid IngressClass" ingress="default/example" ingressclass="nginx"
W0314 12:51:03.101743       7 controller.go:1108] Error obtaining Endpoints for Service "default/exampleservice": no object matching key "default/exampleservice" in local store
I0314 12:51:03.101821       7 controller.go:190] "Configuration changes detected, backend reload required"
I0314 12:51:03.103208       7 event.go:364] Event(v1.ObjectReference{Kind:"Ingress", Namespace:"default", Name:"example", UID:"36c1eedb-7e44-47af-98b4-d7e0bc76dc73", APIVersion:"networking.k8s.io/v1", ResourceVersion:"31202", FieldPath:""}): type: 'Normal' reason: 'Sync' Scheduled for sync
I0314 12:51:03.140365       7 controller.go:210] "Backend successfully reloaded"
I0314 12:51:03.141738       7 event.go:364] Event(v1.ObjectReference{Kind:"Pod", Namespace:"default", Name:"ingress-nginx-controller-55474d95c5-7ngmn", UID:"125656cb-c1f0-4037-bd2d-185a64a0ea2b", APIVersion:"v1", ResourceVersion:"30479", FieldPath:""}): type: 'Normal' reason: 'RELOAD' NGINX reload triggered due to a change in configuration
I0314 12:52:09.109001       7 store.go:403] "Ignoring ingress because of error while validating ingress class" ingress="default/minimal-ingress" error="no object matching key \"nginx-example\" in local store"
W0314 13:20:49.541561       7 controller.go:1108] Error obtaining Endpoints for Service "default/exampleservice": no object matching key "default/exampleservice" in local store
W0314 13:20:52.875878       7 controller.go:1108] Error obtaining Endpoints for Service "default/exampleservice": no object matching key "default/exampleservice" in local store
W0314 13:20:56.209233       7 controller.go:1108] Error obtaining Endpoints for Service "default/exampleservice": no object matching key "default/exampleservice" in local store
W0314 13:21:02.294202       7 controller.go:1108] Error obtaining Endpoints for Service "default/exampleservice": no object matching key "default/exampleservice" in local store
W0314 13:21:10.273508       7 controller.go:1108] Error obtaining Endpoints for Service "default/exampleservice": no object matching key "default/exampleservice" in local store

vagrant@master:~$ kubectl describe svc ingress-nginx-controller
Name:                     ingress-nginx-controller
Namespace:                default
Labels:                   app.kubernetes.io/component=controller
                          app.kubernetes.io/instance=ingress-nginx
                          app.kubernetes.io/managed-by=Helm
                          app.kubernetes.io/name=ingress-nginx
                          app.kubernetes.io/part-of=ingress-nginx
                          app.kubernetes.io/version=1.10.0
                          helm.sh/chart=ingress-nginx-4.10.0
Annotations:              meta.helm.sh/release-name: ingress-nginx
                          meta.helm.sh/release-namespace: default
Selector:                 app.kubernetes.io/component=controller,app.kubernetes.io/instance=ingress-nginx,app.kubernetes.io/name=ingress-nginx
Type:                     LoadBalancer
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.233.48.228
IPs:                      10.233.48.228
Port:                     http  80/TCP
TargetPort:               http/TCP
NodePort:                 http  31984/TCP
Endpoints:                10.233.102.141:80
Port:                     https  443/TCP
TargetPort:               https/TCP
NodePort:                 https  30244/TCP
Endpoints:                10.233.102.141:443
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>

cat example.yml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example
spec:
  ingressClassName: nginx
  rules:
    - host: www.example.com
      http:
        paths:
          - pathType: Prefix
            backend:
              service:
                name: exampleservice
                port:
                  number: 80
            path: /
```