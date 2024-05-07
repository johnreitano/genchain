#!/usr/bin/env bash
# set -x
set -e

SCRIPT_DIR=$(dirname $(readlink -f $0))
cd ${SCRIPT_DIR}/..

ENV=$1
NUM_VALIDATORS=$2
NUM_SEEDS=$3

if [[ ! $ENV =~ ^mainnet|testnet$ || "$NUM_VALIDATORS" -lt "1" || "$NUM_VALIDATORS" -gt "100" || "$NUM_SEEDS" -lt "1" || "$NUM_SEEDS" -gt "100" ]]; then
  echo "Usage: create-servers <mainnet|testnet> <num-validators> <num-seeds>"
  exit 1
fi

if ! test -f "${SCRIPT_DIR}/dns.tfvars"; then
  echo "File dns.tfvars not found - run create-zone.sh before running this script."
  exit 1
fi

terraform -chdir=deploy apply -auto-approve -var="env=${ENV}" -var="num_validator_instances=$NUM_VALIDATORS" -var="num_seed_instances=${NUM_SEEDS}" -var="create_explorer=true" -var-file="dns.tfvars"
