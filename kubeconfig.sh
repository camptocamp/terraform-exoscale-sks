#!/bin/sh

set -e

eval "$(jq -r '@sh "CLUSTER_NAME=\(.cluster_name) ZONE=\(.zone)"')"

kubeconfig=$(exo sks kubeconfig "$CLUSTER_NAME" admin --group system:masters --zone "$ZONE")

jq -n --arg kubeconfig "$kubeconfig" '{"kubeconfig":$kubeconfig}'
