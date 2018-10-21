FROM centos:centos7
LABEL author="Team ngcloud <prabhu.subramanian@gmail.com>"

ENV HELM_VERSION=2.11.0 \
    AWS_IAM_AUTH_VERSION=0.3.0
LABEL RUN="docker run -it --name ngcloud-creator -v ~/.aws:/home/ngcloud/.aws -v ~/.ssh:/home/ngcloud/.ssh ngcloud/creator"

RUN yum -y install \
           file \
           findutils \
           gcc \
           git \
           iproute \
           iputils \
           less \
           make \
           net-tools \
           passwd \
           tar \
           vim-enhanced \
           wget \
           which \
           docker \
           python-docker-py \
           docker-selinux \
           kubernetes-client \
           gdb-gdbserver \
           bash-completion \
           yum-utils \
           && yum clean all \
           && rm -rf /var/cache/yum

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
RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" \
  && python get-pip.py \
  && pip install awscli aws-shell \
  && pip install --upgrade pip \
  && rm get-pip.py

RUN curl "https://get.aquasec.com/microscanner" -o "/usr/local/bin/microscanner" \
    && chmod +x /usr/local/bin/microscanner \
    && if [[ ${aquaToken} ]]; then /usr/local/bin/microscanner ${aquaToken}; fi \
    && rm -rf /usr/local/bin/microscanner

RUN useradd -u 1001 -m -d /home/ngcloud -s /bin/bash ngcloud
USER ngcloud

# Clone bootstrap scripts to have it ready
RUN cd /home/ngcloud \
  && git clone https://github.com/ngcloud/bootstrap.git \
  && chmod +x /home/ngcloud/bootstrap/scripts/*.sh

CMD ["/usr/bin/bash"]
