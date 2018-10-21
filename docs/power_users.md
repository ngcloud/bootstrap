# Kubernetes creation machine - pre-requisites

This is for users not willing to use the creator docker image. We use kops to create a bespoke Kubernetes cluster for ngcloud.

Install kubectl

```bash
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
```

Install helm with tiller

```bash
HELM_VERSION=2.11.0
curl -fsSL "https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz" | tar -xzC /usr/share/helm --strip-components=1
cp /usr/share/helm/* /usr/local/bin/ \
  && chmod +x /usr/local/bin/helm \
  && chmod +x /usr/local/bin/tiller \
  && helm init --client-only
```

Install kops

```bash
curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops-linux-amd64
sudo mv kops-linux-amd64 /usr/local/bin/kops
```

```bash
curl -LO https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.3.0/heptio-authenticator-aws_0.3.0_linux_amd64
chmod +x heptio-authenticator-aws_0.3.0_linux_amd64
sudo mv ./heptio-authenticator-aws_0.3.0_linux_amd64 /usr/local/bin/aws-iam-authenticator
```
