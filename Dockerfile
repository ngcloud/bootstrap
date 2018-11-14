FROM ngcloud/aws-tools

ARG CLI_VERSION
ARG BUILD_DATE

LABEL maintainer="ngCloud" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.vendor="ngCloud" \
      org.label-schema.name="aws tools" \
      org.label-schema.version=$CLI_VERSION \
      org.label-schema.license="MIT" \
      org.label-schema.description="Container with essential tools for creating and managing Kubernetes cluster on aws using kops" \
      org.label-schema.url="https://ngcloud.io" \
      org.label-schema.usage="https://github.com/ngcloud/bootstrap" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/ngcloud/bootstrap.git" \
      org.label-schema.docker.cmd="docker run -it --name ngcloud-creator -v ~/.aws:/home/ngcloud/.aws -v ~/.ssh:/home/ngcloud/.ssh ngcloud/creator"

# Run as ngcloud user
RUN adduser -u 1001 -D -h /home/ngcloud -s /bin/bash ngcloud
USER ngcloud

# Clone bootstrap scripts to have it ready
RUN cd /home/ngcloud \
  && git clone https://github.com/ngcloud/bootstrap.git \
  && chmod +x /home/ngcloud/bootstrap/scripts/*.sh

CMD ["/bin/bash"]
