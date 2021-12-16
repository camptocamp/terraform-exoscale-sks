#!/bin/sh

set -e

eval "$(jq -r '@sh "CLUSTER_ID=\(.cluster_id) ZONE=\(.zone)"')"

kubeconfig=$(exo sks kubeconfig "$CLUSTER_ID" kube-admin --group system:masters --zone "$ZONE")

jq -M -n --arg kubeconfig "$kubeconfig" '{"kubeconfig":$kubeconfig}'
