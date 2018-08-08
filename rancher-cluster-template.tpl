nodes:
  - address: ${ip-add1} # hostname or IP to access nodes
    user: rancher # root user (usually 'root')
    role: [controlplane,etcd,worker] # K8s roles for node
    ssh_key_path: ${key-path}rancherv2.pem # path to PEM file
  - address: ${ip-add2} # hostname or IP to access nodes
    user: rancher # root user (usually 'root')
    role: [controlplane,etcd,worker] # K8s roles for node
    ssh_key_path: ${key-path}rancherv2.pem # path to PEM file
  - address: ${ip-add3} # hostname or IP to access nodes
    user: rancher # root user (usually 'root')
    role: [controlplane,etcd,worker] # K8s roles for node
    ssh_key_path: ${key-path}rancherv2.pem # path to PEM file
addons: |-
  ---
  kind: Namespace
  apiVersion: v1
  metadata:
    name: cattle-system
  ---
  kind: ServiceAccount
  apiVersion: v1
  metadata:
    name: cattle-admin
    namespace: cattle-system
  ---
  kind: ClusterRoleBinding
  apiVersion: rbac.authorization.k8s.io/v1
  metadata:
    name: cattle-crb
    namespace: cattle-system
  subjects:
  - kind: ServiceAccount
    name: cattle-admin
    namespace: cattle-system
  roleRef:
    kind: ClusterRole
    name: cluster-admin
    apiGroup: rbac.authorization.k8s.io
  ---
   apiVersion: v1
  kind: Secret
  metadata:
    name: cattle-keys-ingress
    namespace: cattle-system
  type: Opaque
  data:
    tls.key: ${rancher-pkey}
    tls.crt: ${rancher-pcert}
  ---
  apiVersion: v1
  kind: Secret
  metadata:
    name: cattle-keys-server
    namespace: cattle-system
  type: Opaque
  data:
    cacerts.pem: ${rancher-pcert}
  ---
  apiVersion: v1
  kind: Service
  metadata:
    namespace: cattle-system
    name: cattle-service
    labels:
      app: cattle
  spec:
    ports:
    - port: 80
      targetPort: 80
      protocol: TCP
      name: http
    - port: 443
      targetPort: 443
      protocol: TCP
      name: https
    selector:
      app: cattle
  ---
  apiVersion: extensions/v1beta1
  kind: Ingress
  metadata:
    namespace: cattle-system
    name: cattle-ingress-http
    annotations:
      nginx.ingress.kubernetes.io/proxy-connect-timeout: "30"
      nginx.ingress.kubernetes.io/proxy-read-timeout: "1800"   # Max time in seconds for ws to remain shell window open
      nginx.ingress.kubernetes.io/proxy-send-timeout: "1800"   # Max time in seconds for ws to remain shell window open
  spec:
    rules:
    - host: rancherv4.greensill.cloud
      http:
        paths:
        - backend:
            serviceName: cattle-service
            servicePort: 80
  ---
  kind: Deployment
  apiVersion: extensions/v1beta1
  metadata:
    namespace: cattle-system
    name: cattle
  spec:
    replicas: 1
    template:
      metadata:
        labels:
          app: cattle
      spec:
        serviceAccountName: cattle-admin
        containers:
        - image: rancher/rancher:latest
          imagePullPolicy: Always
          name: cattle-server
          ports:
          - containerPort: 80
            protocol: TCP
          volumeMounts:
          - mountPath: /etc/rancher/ssl
            name: cattle-keys-volume
            readOnly: true
        volumes:
        - name: cattle-keys-volume
          secret:
            defaultMode: 420
            secretName: cattle-keys-server