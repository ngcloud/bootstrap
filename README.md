[![Build Status](https://dev.azure.com/ngcloud/creator/_apis/build/status/ngcloud.bootstrap)](https://dev.azure.com/ngcloud/creator/_build/latest?definitionId=1) [![Docker Repository on Quay](https://quay.io/repository/ngcloud/creator/status "Docker Repository on Quay")](https://quay.io/repository/ngcloud/creator)

# ngcloud

ngcloud is coming soon

## Quick start

### AWS using kops

Bootstrap scripts are available as a docker image. Simply pull the image and run the image by mounting your ssh and aws credentials directory.

```bash
docker pull ngcloud/creator # or docker pull quay.io/ngcloud/creator
docker run --rm -it --name ngcloud-creator -v ~/.aws:/home/ngcloud/.aws -v ~/.ssh:/home/ngcloud/.ssh ngcloud/creator
```

Continue with the cloud creation from within the docker bash shell

```bash
cd ~/bootstrap/scripts
# vi aws-setup.sh and configure
./aws-setup.sh create # Get a coffee or two
./aws-setup.sh bastion # Save the config without any change to proceed
```

```bash
./aws-setup.sh iam-auth
```

### Azure with AKS

```bash
docker pull ngcloud/azure-creator
docker run --rm -it --name ngcloud-creator -v ~/.azure:/home/ngcloud/.azure ngcloud/azure-creator
```

## Power users

For users not willing to use the creator docker image follow the instructions in [power users](https://github.com/ngcloud/bootstrap/blob/master/docs/power_users.md) to setup your computer or vm

## Support/question/discussion

We use [Discord](https://discord.gg/BamQKyp) for chat. GitHub issues is also best.
