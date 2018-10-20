FROM centos:centos7
LABEL author="ngcloud <prabhu.subramanian@gmail.com>"

ENV HELM_VERSION=2.11.0
LABEL RUN="docker run -it --name NAME -e NAME=NAME IMAGE"

RUN yum -y install \
           kernel \
           e2fsprogs \
           sos \
           crash \
           strace \
           ltrace \
           tcpdump \
           abrt \
           pcp \
           systemtap \
           perf \
           bc \
           blktrace \
           btrfs-progs \
           ethtool \
           file \
           findutils \
           gcc \
           gdb \
           git \
           glibc-common \
           glibc-utils \
           hwloc \
           iotop \
           iproute \
           iputils \
           less \
           pciutils \
           ltrace \
           mailx \
           man-db \
           nc \
           netsniff-ng \
           net-tools \
           numactl \
           numactl-devel \
           passwd \
           perf \
           procps-ng \
           psmisc \
           screen \
           strace \
           sysstat \
           systemtap-client \
           tar \
           tcpdump \
           vim-enhanced \
           xauth \
           which \
           ostree \
           rpm-ostree \
           docker \
           python-docker-py \
           docker-selinux \
           kubernetes-client \
           gdb-gdbserver \
           vim-minimal \
           bash-completion \
           subscription-manager \
           python-rhsm \
           rootfiles \
           yum-utils \
           && yum clean all \
           && rm -rf /var/cache/yum

# Install helm
RUN mkdir -p /usr/share/helm && curl -fsSL "https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz" | tar -xzC /usr/share/helm --strip-components=1 \
  && cp /usr/share/helm/* /usr/local/bin/ \
  && chmod +x /usr/local/bin/helm \
  && chmod +x /usr/local/bin/tiller \
  && helm init --client-only

# Install kops
RUN curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64 \
  && chmod +x kops-linux-amd64 \
  && mv kops-linux-amd64 /usr/local/bin/kops

# Install aws iam authenticator
RUN curl -LO https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.3.0/heptio-authenticator-aws_0.3.0_linux_amd64 \
  && chmod +x heptio-authenticator-aws_0.3.0_linux_amd64 \
  && mv ./heptio-authenticator-aws_0.3.0_linux_amd64 /usr/local/bin/aws-iam-authenticator

RUN useradd -u 1001 -m -d /home/ngcloud -s /bin/bash ngcloud
USER ngcloud

# Clone bootstrap scripts to have it ready
RUN cd /home/ngcloud \
  && git clone https://github.com/ngcloud/bootstrap.git

CMD ["/usr/bin/bash"]
