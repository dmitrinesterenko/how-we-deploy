### Kubernetes

## Why?
* To deploy a simple Rails application into a Kubernetes cluster
* To understand the importance of the Kubernetes cluster management solution
* To see how an application can get launched along side other applications.

## How?
Follow the install instructions [here](https://github.com/kubernetes/minikube) to get a local Kubernetes cluster set up via
Minikube. Follow those instructions to also install kubectl the Kubernetes
management tool as well as an appopriate virtual machine for your operation
system.

Minikube is a fun way to approximate how working with a Kubernetes
cluster would work for you in a production environment.

Install [kube-shell](https://github.com/cloudnativelabs/kube-shell) to make the kubectl commands come to life and be documented as you type.

* `minikube start`
* `eval $(minikube docker-env)`
* `./scripts/docker/build.sh` to build the docker image on the docker machine that the Kubernetes cluster provides via Minikube.
* `kube-shell` to launch the kubectl enabled shell that helps with command  completion and auto documentation.
* > `kubectl run gifer --image=how_we_deploy:1.0 --port 3000` note that our
 application is meant to expose port 3000 as it's the default port for Rails
 apps.
* `kubectl get` to get the pods and the deployments that are created as a result
* > `kubectl expose deployment gifer --type=LoadBalancer`  to expose our webapp to the outside world
* `kubectl get services` to view our newly exposed service
* `minikube service gifer` to launch the app on the minikube IP and the minikube
  assigned port that maps to the internal port of 3000. The minikube IP is the
  IP of the virtual machine that is running the Kubernetes cluster.

## Cleanup
* kubectl delete deployment gifer
* kubectl delete service gifer

## Want more?!
Of course! [Go
here](https://kubernetes.io/docs/tutorials/stateless-application/hello-minikube)!


## Pricint?
It depends on where your Kubernetes cluster is deployed. Kubernetes or K8s can
be deployed on Google Cloud Compute (where it had originated), AWS, Azure and
datacenters.


