FROM alpine
LABEL author="Team ngcloud <prabhu.subramanian@gmail.com>"

ENV HELM_VERSION=2.11.0 \
    AWS_IAM_AUTH_VERSION=0.3.0 \
    TF_VERSION=0.11.9

LABEL RUN="docker run -it --name ngcloud-creator -v ~/.aws:/home/ngcloud/.aws -v ~/.ssh:/home/ngcloud/.ssh ngcloud/creator"
ARG aquaToken

RUN apk --update add --no-cache python py-pip zip tar make bash wget curl git openssh-client \
    && rm -rf /var/lib/apt/lists/*
RUN apk add --no-cache ca-certificates && update-ca-certificates

# Setup kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
  && chmod +x ./kubectl \
  && mv ./kubectl /usr/local/bin/kubectl

# Install helm
RUN mkdir -p /usr/share/helm && curl -fsSL "https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz" | tar -xzC /usr/share/helm --strip-components=1 \
  && cp /usr/share/helm/* /usr/local/bin/ \
  && chmod +x /usr/local/bin/helm \
  && chmod +x /usr/local/bin/tiller \
  && helm init --client-only \
  && helm plugin install https://github.com/hypnoglow/helm-s3.git

# Install kops
RUN curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64 \
  && chmod +x kops-linux-amd64 \
  && mv kops-linux-amd64 /usr/local/bin/kops

# Install aws iam authenticator
RUN curl -LO https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${AWS_IAM_AUTH_VERSION}/heptio-authenticator-aws_${AWS_IAM_AUTH_VERSION}_linux_amd64 \
  && chmod +x heptio-authenticator-aws_${AWS_IAM_AUTH_VERSION}_linux_amd64 \
  && mv ./heptio-authenticator-aws_${AWS_IAM_AUTH_VERSION}_linux_amd64 /usr/local/bin/aws-iam-authenticator

# Install awscli
RUN pip install awscli aws-shell \
  && pip install --upgrade pip

# Install terraform
RUN curl -LO https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip \
  && unzip terraform_${TF_VERSION}_linux_amd64.zip -d /usr/local/bin \
  && chmod +x /usr/local/bin/terraform \
  && rm terraform_${TF_VERSION}_linux_amd64.zip

# Scan with aqua
RUN curl "https://get.aquasec.com/microscanner" -o "/usr/local/bin/microscanner" \
  && chmod +x /usr/local/bin/microscanner \
  && /usr/local/bin/microscanner $aquaToken \
  && rm -rf /usr/local/bin/microscanner

# Run as ngcloud user
RUN adduser -u 1001 -D -h /home/ngcloud -s /bin/bash ngcloud
USER ngcloud

# Clone bootstrap scripts to have it ready
RUN cd /home/ngcloud \
  && git clone https://github.com/ngcloud/bootstrap.git \
  && chmod +x /home/ngcloud/bootstrap/scripts/*.sh

CMD ["/usr/bin/bash"]
