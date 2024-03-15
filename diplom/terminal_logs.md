```
vagrant@server:~/diplom/app$ kubectl get pods -o wide
NAME                                                   READY   STATUS    RESTARTS   AGE     IP               NODE    NOMINATED NODE   READINESS GATES
my-deployment-7cd6969b7b-gssgx                         1/1     Running   0          3h22m   10.233.102.131   node1   <none>           <none>
my-deployment-7cd6969b7b-lnhnw                         1/1     Running   0          3h22m   10.233.75.2      node2   <none>           <none>
my-release-nginx-ingress-controller-6cd97fb65b-595bp   1/1     Running   0          3h26m   10.233.102.130   node1   <none>           <none>
vagrant@server:~/diplom/app$

vagrant@server:~/diplom/app$ kubectl get svc
NAME                                  TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
kubernetes                            ClusterIP      10.233.0.1      <none>        443/TCP                      3h33m
my-release-nginx-ingress-controller   LoadBalancer   10.233.46.16    <pending>     80:32092/TCP,443:31841/TCP   3h23m
myapp                                 ClusterIP      10.233.18.245   <none>        80/TCP                       3h19m
myappfornginx                         NodePort       10.233.49.236   <none>        80:30080/TCP                 19m

vagrant@server:~/diplom/app$ kubectl get ingress
NAME    CLASS   HOSTS       ADDRESS   PORTS   AGE
myapp   nginx   myapp.net             80      104m


vagrant@server:~/diplom/app$ kubectl describe svc my-release-nginx-ingress-controller
Name:                     my-release-nginx-ingress-controller
Namespace:                default
Labels:                   app.kubernetes.io/instance=my-release
                          app.kubernetes.io/managed-by=Helm
                          app.kubernetes.io/name=nginx-ingress
                          app.kubernetes.io/version=3.4.3
                          helm.sh/chart=nginx-ingress-1.1.3
Annotations:              meta.helm.sh/release-name: my-release
                          meta.helm.sh/release-namespace: default
Selector:                 app.kubernetes.io/instance=my-release,app.kubernetes.io/name=nginx-ingress
Type:                     LoadBalancer
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.233.46.16
IPs:                      10.233.46.16
Port:                     http  80/TCP
TargetPort:               80/TCP
NodePort:                 http  32092/TCP
Endpoints:                10.233.102.130:80
Port:                     https  443/TCP
TargetPort:               443/TCP
NodePort:                 https  31841/TCP
Endpoints:                10.233.102.130:443
Session Affinity:         None
External Traffic Policy:  Local
HealthCheck NodePort:     31372
Events:                   <none>


vagrant@server:~/diplom/app$ kubectl describe svc myappfornginx
Name:                     myappfornginx
Namespace:                default
Labels:                   <none>
Annotations:              <none>
Selector:                 app=myapp
Type:                     NodePort
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.233.49.236
IPs:                      10.233.49.236
Port:                     http  80/TCP
TargetPort:               myapp/TCP
NodePort:                 http  30080/TCP
Endpoints:                <none>
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>

vagrant@server:~/diplom/app$ kubectl describe svc myapp
Name:              myapp
Namespace:         default
Labels:            <none>
Annotations:       <none>
Selector:          app=myapp
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                10.233.18.245
IPs:               10.233.18.245
Port:              http  80/TCP
TargetPort:        myapphttp/TCP
Endpoints:         10.233.102.131:80,10.233.75.2:80
Session Affinity:  None
Events:            <none>


```
