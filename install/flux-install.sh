#!/bin/bash


echo 
alias kubectl='microk8s.kubectl'

cat <<'EOF' >> ~/.bash_aliases
alias kubectl='microk8s.kubectl'
EOF

kubectl create ns flux

sudo snap install fluxctl

#microk8s workaround
microk8s.kubectl config view --raw > $HOME/.kube/config


# https://docs.fluxcd.io/en/latest/tutorials/get-started/

#fork


## basic config without kustomize
export GHUSER="JoseIbanez"
fluxctl install \
--git-user=${GHUSER} \
--git-email=${GHUSER}@users.noreply.github.com \
--git-url=git@github.com:${GHUSER}/flux-get-started \
--git-path=namespaces,workloads \
--namespace=flux | kubectl apply -f -

kubectl -n flux rollout status deployment/flux



## using kustomize
export GHUSER="JoseIbanez"
fluxctl install \
--git-user=${GHUSER} \
--git-email=${GHUSER}@users.noreply.github.com \
--git-url=git@github.com:${GHUSER}/flux-get-started \
--git-path=dev \
--manifest-generation=true \
--namespace=flux | kubectl apply -f -

kubectl -n flux rollout status deployment/flux


#syncronize
fluxctl sync --k8s-fwd-ns flux


#get ssh key and configure in github, add write rights
fluxctl identity --k8s-fwd-ns flux


