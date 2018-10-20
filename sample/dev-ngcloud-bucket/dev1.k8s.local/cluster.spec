metadata:
  creationTimestamp: 2018-10-19T21:06:35Z
  name: dev1.k8s.local
spec:
  api:
    loadBalancer:
      type: Internal
  authorization:
    rbac: {}
  channel: stable
  cloudLabels:
    Purpose: Dev
    Team: Dev
  cloudProvider: aws
  clusterDNSDomain: cluster.local
  configBase: s3://dev-ngcloud-bucket/dev1.k8s.local
  configStore: s3://dev-ngcloud-bucket/dev1.k8s.local
  dnsZone: k8s.local
  docker:
    ipMasq: false
    ipTables: false
    logDriver: json-file
    logLevel: warn
    logOpt:
    - max-size=10m
    - max-file=5
    storage: overlay2,overlay,aufs
    version: 17.03.2
  etcdClusters:
  - backups:
      backupStore: s3://dev-ngcloud-bucket/dev1.k8s.local/backups/etcd/main
    etcdMembers:
    - encryptedVolume: true
      instanceGroup: master-eu-west-2a
      name: a
    - encryptedVolume: true
      instanceGroup: master-eu-west-2b
      name: b
    - encryptedVolume: true
      instanceGroup: master-eu-west-2c
      name: c
    manager: {}
    name: main
    provider: Manager
    version: 3.2.24
  - backups:
      backupStore: s3://dev-ngcloud-bucket/dev1.k8s.local/backups/etcd/events
    etcdMembers:
    - encryptedVolume: true
      instanceGroup: master-eu-west-2a
      name: a
    - encryptedVolume: true
      instanceGroup: master-eu-west-2b
      name: b
    - encryptedVolume: true
      instanceGroup: master-eu-west-2c
      name: c
    manager: {}
    name: events
    provider: Manager
    version: 3.2.24
  iam:
    allowContainerRegistry: true
    legacy: false
  keyStore: s3://dev-ngcloud-bucket/dev1.k8s.local/pki
  kubeAPIServer:
    allowPrivileged: true
    anonymousAuth: false
    apiServerCount: 3
    authorizationMode: RBAC
    bindAddress: 0.0.0.0
    cloudProvider: aws
    enableAdmissionPlugins:
    - Initializers
    - NamespaceLifecycle
    - LimitRanger
    - ServiceAccount
    - PersistentVolumeLabel
    - DefaultStorageClass
    - DefaultTolerationSeconds
    - MutatingAdmissionWebhook
    - ValidatingAdmissionWebhook
    - NodeRestriction
    - ResourceQuota
    etcdServers:
    - http://127.0.0.1:4001
    etcdServersOverrides:
    - /events#http://127.0.0.1:4002
    image: k8s.gcr.io/kube-apiserver:v1.12.0
    insecureBindAddress: 127.0.0.1
    insecurePort: 8080
    kubeletPreferredAddressTypes:
    - InternalIP
    - Hostname
    - ExternalIP
    logLevel: 2
    requestheaderAllowedNames:
    - aggregator
    requestheaderExtraHeaderPrefixes:
    - X-Remote-Extra-
    requestheaderGroupHeaders:
    - X-Remote-Group
    requestheaderUsernameHeaders:
    - X-Remote-User
    securePort: 443
    serviceClusterIPRange: 100.64.0.0/13
    storageBackend: etcd3
  kubeControllerManager:
    allocateNodeCIDRs: true
    attachDetachReconcileSyncPeriod: 1m0s
    cloudProvider: aws
    clusterCIDR: 100.96.0.0/11
    clusterName: dev1.k8s.local
    configureCloudRoutes: false
    image: k8s.gcr.io/kube-controller-manager:v1.12.0
    leaderElection:
      leaderElect: true
    logLevel: 2
    useServiceAccountCredentials: true
  kubeDNS:
    cacheMaxConcurrent: 150
    cacheMaxSize: 1000
    domain: cluster.local
    replicas: 2
    serverIP: 100.64.0.10
  kubeProxy:
    clusterCIDR: 100.96.0.0/11
    cpuRequest: 100m
    hostnameOverride: '@aws'
    image: k8s.gcr.io/kube-proxy:v1.12.0
    logLevel: 2
  kubeScheduler:
    image: k8s.gcr.io/kube-scheduler:v1.12.0
    leaderElection:
      leaderElect: true
    logLevel: 2
  kubelet:
    allowPrivileged: true
    cgroupRoot: /
    cloudProvider: aws
    clusterDNS: 100.64.0.10
    clusterDomain: cluster.local
    enableDebuggingHandlers: true
    evictionHard: memory.available<100Mi,nodefs.available<10%,nodefs.inodesFree<5%,imagefs.available<10%,imagefs.inodesFree<5%
    featureGates:
      ExperimentalCriticalPodAnnotation: "true"
    hostnameOverride: '@aws'
    kubeconfigPath: /var/lib/kubelet/kubeconfig
    logLevel: 2
    networkPluginName: cni
    nonMasqueradeCIDR: 100.64.0.0/10
    podInfraContainerImage: k8s.gcr.io/pause-amd64:3.0
    podManifestPath: /etc/kubernetes/manifests
  kubernetesApiAccess:
  - 0.0.0.0/0
  kubernetesVersion: 1.12.0
  masterInternalName: api.internal.dev1.k8s.local
  masterKubelet:
    allowPrivileged: true
    cgroupRoot: /
    cloudProvider: aws
    clusterDNS: 100.64.0.10
    clusterDomain: cluster.local
    enableDebuggingHandlers: true
    evictionHard: memory.available<100Mi,nodefs.available<10%,nodefs.inodesFree<5%,imagefs.available<10%,imagefs.inodesFree<5%
    featureGates:
      ExperimentalCriticalPodAnnotation: "true"
    hostnameOverride: '@aws'
    kubeconfigPath: /var/lib/kubelet/kubeconfig
    logLevel: 2
    networkPluginName: cni
    nonMasqueradeCIDR: 100.64.0.0/10
    podInfraContainerImage: k8s.gcr.io/pause-amd64:3.0
    podManifestPath: /etc/kubernetes/manifests
    registerSchedulable: false
  masterPublicName: api.dev1.k8s.local
  networkCIDR: 172.20.0.0/16
  networking:
    calico: {}
  nonMasqueradeCIDR: 100.64.0.0/10
  secretStore: s3://dev-ngcloud-bucket/dev1.k8s.local/secrets
  serviceClusterIPRange: 100.64.0.0/13
  sshAccess:
  - 0.0.0.0/0
  subnets:
  - cidr: 172.20.32.0/19
    name: eu-west-2a
    type: Private
    zone: eu-west-2a
  - cidr: 172.20.64.0/19
    name: eu-west-2b
    type: Private
    zone: eu-west-2b
  - cidr: 172.20.96.0/19
    name: eu-west-2c
    type: Private
    zone: eu-west-2c
  - cidr: 172.20.0.0/22
    name: utility-eu-west-2a
    type: Utility
    zone: eu-west-2a
  - cidr: 172.20.4.0/22
    name: utility-eu-west-2b
    type: Utility
    zone: eu-west-2b
  - cidr: 172.20.8.0/22
    name: utility-eu-west-2c
    type: Utility
    zone: eu-west-2c
  topology:
    dns:
      type: Private
    masters: private
    nodes: private
