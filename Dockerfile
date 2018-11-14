FROM ngcloud/aws-tools
LABEL author="Team ngcloud <hello@ngcloud.io>"

LABEL RUN="docker run -it --name ngcloud-creator -v ~/.aws:/home/ngcloud/.aws -v ~/.ssh:/home/ngcloud/.ssh ngcloud/creator"

# Run as ngcloud user
RUN adduser -u 1001 -D -h /home/ngcloud -s /bin/bash ngcloud
USER ngcloud

# Clone bootstrap scripts to have it ready
RUN cd /home/ngcloud \
  && git clone https://github.com/ngcloud/bootstrap.git \
  && chmod +x /home/ngcloud/bootstrap/scripts/*.sh

CMD ["/usr/bin/bash"]
