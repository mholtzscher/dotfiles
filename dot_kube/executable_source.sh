#!/bin/bash
OIFS="$IFS"
IFS=$'\n'
for kubeconfigFile in `find "$HOME/.kube" -type f -name "*.yml" -o -name "*.yaml"`
do
    export KUBECONFIG="$kubeconfigFile:$KUBECONFIG"
done
IFS="$OIFS"
