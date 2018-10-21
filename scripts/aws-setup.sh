#!/usr/bin/env bash

set -ueo pipefail

CLUSTER_CREATOR_GROUP=ngcloud-kops
CLUSTER_CREATOR_USER=ngcloud-kops
DNS_ZONE="k8s.local"
CLUSTER_NAME="dev1.${DNS_ZONE}"
MASTER_ZONES="eu-west-2a,eu-west-2b,eu-west-2c"
ZONES=${MASTER_ZONES:-"eu-west-2a,eu-west-2b,eu-west-2c"}
NODE_COUNT=1
export NODE_SIZE="t2.micro" #t2.medium
export MASTER_SIZE="t2.micro"
TOPOLOGY="private" #other values: public
DNS_MODE="private" #other values: public
NETWORKING="calico" #other values: kopeio-vxlan or weave or cni canal, kube-router, romana, amazon-vpc-routed-eni, cilium
IMAGE_NAME="410186602215/CentOS Atomic Host 7 x86_64 HVM EBS 1706_01"
K8_VERSION="1.12.0"
LABELS="Team=Dev,Purpose=Dev"
export KOPS_STATE_STORE="s3://dev-ngcloud-bucket"
API_LB_TYPE="internal" #public
API_SSL_ARN=""
SSH_KEY="~/.ssh/id_rsa.pub"
ALLOWED_IP="0.0.0.0/0"
BASTION_DNS_ZONE="ngcloud.io"
BASTION_NAME="dev-ngcloud-bastions.${BASTION_DNS_ZONE}"
BASTION_SUBNET="utility-eu-west-2a"

setupCreatorGroup() {
  echo "Setting up creator group $CLUSTER_CREATOR_GROUP"
  aws iam create-group --group-name $CLUSTER_CREATOR_GROUP
  aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --group-name $CLUSTER_CREATOR_GROUP
  aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonRoute53FullAccess --group-name $CLUSTER_CREATOR_GROUP
  aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --group-name $CLUSTER_CREATOR_GROUP
  aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/IAMFullAccess --group-name $CLUSTER_CREATOR_GROUP
  aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess --group-name $CLUSTER_CREATOR_GROUP
}

setupCreatorUser() {
  echo "Setting up creator user $CLUSTER_CREATOR_USER"
  aws iam create-user --user-name $CLUSTER_CREATOR_USER
  aws iam add-user-to-group --user-name $CLUSTER_CREATOR_USER --group-name $CLUSTER_CREATOR_GROUP
  aws iam create-access-key --user-name $CLUSTER_CREATOR_USER
}

createClusterScript() {
  echo "About to create $1"
  EXTRA_ARGS=""
  if [[ $2 = "cloudformation" ]] || [[ $2 = "terraform" ]]; then
    EXTRA_ARGS="--target=${2}"
  elif [[ $2 = "dry-run" ]]; then
    EXTRA_ARGS="--dry-run --output=yaml"
  elif [[ $2 = "yes" ]]; then
    EXTRA_ARGS="--yes"
  fi
  kops create cluster \
    --node-count=${NODE_COUNT} \
    --api-loadbalancer-type=${API_LB_TYPE} \
    --cloud=aws \
    --state=${KOPS_STATE_STORE} \
    --admin-access=${ALLOWED_IP} \
    --ssh-access=${ALLOWED_IP} \
    --zones=${ZONES} \
    --authorization="RBAC" \
    --encrypt-etcd-storage \
    --master-zones=${MASTER_ZONES} \
    --dns=${DNS_MODE} \
    --ssh-public-key=${SSH_KEY} \
    --dns-zone=${DNS_ZONE} \
    --node-size=${NODE_SIZE} \
    --master-size=${MASTER_SIZE} \
    --topology=${TOPOLOGY} \
    --networking=${NETWORKING} \
    --kubernetes-version=${K8_VERSION} \
    --cloud-labels=${LABELS} \
    ${EXTRA_ARGS} \
    --logtostderr --v 2 \
    --image="${IMAGE_NAME}" \
    $1
}
deleteCluster() {
  echo "About to delete $1"
  EXTRA_ARGS=""
  if [[ $2 = "yes" ]]; then
    EXTRA_ARGS="--yes"
  fi
  kops delete cluster \
    --state=${KOPS_STATE_STORE} \
    --logtostderr --v 2 \
    ${EXTRA_ARGS} \
    $1
}
updateCluster() {
  echo "About to update $1"
  EXTRA_ARGS=""
  if [[ $2 = "yes" ]]; then
    EXTRA_ARGS="--yes"
  fi
  kops update cluster \
    --state=${KOPS_STATE_STORE} \
    --logtostderr --v 2 \
    ${EXTRA_ARGS} \
    $1
}
createBastion() {
  echo "Create Bastion ${BASTION_NAME}"
  kops create instancegroup bastions \
    --name $1 \
    --role Bastion \
    --subnet ${BASTION_SUBNET}
}
exportCluster() {
  echo "About to export $1"
  kops export kubecfg \
    --state=${KOPS_STATE_STORE} \
    --logtostderr --v 2 \
    $1
}
setupIAMAuth() {
  echo "About to setup IAM auth for $1"
  aws-iam-authenticator init -i $1
  aws s3 cp cert.pem $2/$1/addons/authenticator/cert.pem;
  aws s3 cp key.pem $2/$1/addons/authenticator/key.pem;
  aws s3 cp aws-iam-authenticator.kubeconfig $2/$1/addons/authenticator/kubeconfig.yaml;
  rm cert.pem key.pem aws-iam-authenticator.kubeconfig
}
validateCluster() {
  kops validate cluster --name $1 \
    --state=$2
}
case "${1:-"script"}" in
  "script")
    createClusterScript ${CLUSTER_NAME} cloudformation
  ;;
  "dry-run")
    createClusterScript ${CLUSTER_NAME} $1
  ;;
  "create")
    createClusterScript ${CLUSTER_NAME} "yes"
  ;;
  "delete")
    deleteCluster ${CLUSTER_NAME} "yes"
  ;;
  "update")
    updateCluster ${CLUSTER_NAME} "yes"
  ;;
  "export")
    exportCluster ${CLUSTER_NAME}
  ;;
  "bastion")
    createBastion ${CLUSTER_NAME}
    updateCluster ${CLUSTER_NAME} "yes"
  ;;
  "iam-auth")
    setupIAMAuth ${CLUSTER_NAME} ${KOPS_STATE_STORE}
  ;;
  "validate")
    validateCluster ${CLUSTER_NAME} ${KOPS_STATE_STORE}
  ;;
esac
