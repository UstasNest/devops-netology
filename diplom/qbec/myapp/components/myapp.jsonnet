local p = import '../params.libsonnet';
local params = p.components.myapp;

[
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: 'my-deployment',
      namespace: 'ingress-nginx',
      labels: {
       app: 'myapp'
      },
    },
  
    spec: { 
     replicas: 1,
     selector: {
       matchLabels: {
         app: 'myapp',
       },
     },
     template: {
       metadata: {
         labels: {
           app: 'myapp'
         },
       },
       spec: {
         containers: [ { 
             name: 'myapp',
             image: 'rmulyukov/nginxtest',
             ports : [ { 
               containerPort: 80,
               name: 'myapphttp',
             }, 
             ]
         },
         ]
       },
     },
    },
  },
  {
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      name: 'myapp-svc',
      namespace: 'ingress-nginx',
    },
    spec: {
      type: 'NodePort',
      selector: {
        app: 'myapp',
      },
    
      ports: [ { 
          name: 'http',
          port: 80,
          targetPort: 'myapphttp',
          nodePort: 30080,
      },
      ] 
    },  
  }
  
]
