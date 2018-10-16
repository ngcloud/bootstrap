### Prerequisites

### Installation

Multipass from Ubuntu allows you to run ubuntu VMs cleanly on a mac using hypervisor. [Install multipass](https://github.com/CanonicalLtd/multipass/releases) cli by running the pkg installer from github.

Setup a new ubuntu vm

```bash
multipass launch --name ubuntu-vm
```

### Kubernetes setup

Enter the shell for the new vm

```bash
multipass shell ubuntu-vm
sudo apt update
sudo apt upgrade -y
```

Setup lxd

```bash
sudo snap install lxd
/snap/bin/lxd init
# Use all default settings. Choose no for ipv6
```

Check lxd installation

```bash
multipass@ubuntu-vm:~$ /snap/bin/lxc storage show default
config:
  size: 15GB
  source: /var/snap/lxd/common/lxd/disks/default.img
  zfs.pool_name: default
description: ""
name: default
driver: zfs
used_by:
- /1.0/profiles/default
status: Created
locations:
- none
```

lxd network

```bash
multipass@ubuntu-vm:~$ /snap/bin/lxc network show lxdbr0
config:
  ipv4.address: 10.104.14.1/24
  ipv4.nat: "true"
  ipv6.address: none
  ipv6.nat: "false"
description: ""
name: lxdbr0
type: bridge
used_by: []
managed: true
status: Created
locations:
- none
```

Install [conjure-up tool](http://conjure-up.io/)

```bash
sudo snap install conjure-up --classic
sudo usermod -a -G lxd $(whoami)
```

```bash
conjure-up kubernetes
```

Settings

- Canonical Distribution of Kubernetes
- Addons: Helm, Prometheus
- `localhost` for deployment
- calico for network plugin

```
sudo snap install kubectl --classic
```
