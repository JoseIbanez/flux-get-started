#!bin/bash

# install
wget https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.12.1/kubeseal-linux-amd64 -O kubeseal
sudo install -m 755 kubeseal /usr/local/bin/kubeseal

kubectl apply -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.12.1/controller.yaml



# Create a json/yaml-encoded Secret somehow:
# (note use of `--dry-run` - this is just a local file!)
$ echo -n bar | kubectl create secret generic mysecret --dry-run --from-file=foo=/dev/stdin -o json >mysecret.json

# This is the important bit:
# (note default format is json!)
$ kubeseal <mysecret.json >mysealedsecret.json

# mysealedsecret.json is safe to upload to github, post to twitter,
# etc.  Eventually:
$ kubectl create -f mysealedsecret.json

# Profit!
$ kubectl get secret mysecret

#---------------

kubectl create secret generic vro-credentials \
    --dry-run=client \
    -n dev-demo \
    --from-file /vagrant/VF-CI-DEVOPS/sample-config/vro-credentials.yml \
    -o yaml > scrt-vro-credentials.yaml

kubectl create secret generic vro \
    --dry-run=client \
    -n dev-demo \
    --from-file /vagrant/VF-CI-DEVOPS/sample-config/vro.yml \
    -o yaml > scrt-vro.yaml

kubeseal <scrt-vro.yaml >sealed-vro.yaml
kubeseal <scrt-vro-credentials.yaml >sealed-vro-credentials.yaml

