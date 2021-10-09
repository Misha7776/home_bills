#!/bin/sh -ex
#export KUBECONFIG=~/.kube/kubernetes-rails-example-kubeconfig.yaml
docker build -t gufy/home_bills:latest ../../.
docker push gufy/home_bills:latest
kubectl delete deployment home-bills-rails-app
kubectl delete deployment home-bills-sidekiq
kubectl apply -f ./deployment.yml
kubectl apply -f ./sidekiq.yaml
# For Kubernetes >= 1.15 replace the last two lines with the following
# in order to have rolling restarts without downtime
#kubectl rollout update deployment/home-bills-rails-app
#kubectl rollout update deployment/home-bills-sidekiq