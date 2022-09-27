

# Setup

## Requirements
* Have a look at [Getting Started with Amazon EKS](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html)

* Install [kubectl 1.21](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html), [eksctl](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html) and [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html).

* Create an AWS IAM user with at least [minimum iam policies for EKS](https://eksctl.io/usage/minimum-iam-policies/)

* [Configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-config) your AWS CLI to use your EKS enabled user.

## Create EKS cluster
Go to k8s folder:
```
cd k8s
```

Create an EKS cluster with some nodes:
```
eksctl create cluster --name afuentes-webinar-k8s-ha --nodes 3 --version 1.21 --node-type t2.medium  --region eu-west-1 --ssh-access
```

## Install IKO (InterSystems Kubernetes Operator)
* Create a secret called `intersystems-pull-secret` to pull images from intersystems container repository:
```
kubectl create secret docker-registry intersystems-pull-secret \
--docker-server=https://containers.intersystems.com \
--docker-username='<username>' \
--docker-password='<password>' \
--docker-email='<email>'
```

* Download & unzip `iris_operator-3.3.0.120` from [WRC SW Distribution](https://wrc.intersystems.com/wrc/coDistGen.csp).

* Edit `iris_operator-3.3.0.120/chart/iris-operator/values.yaml` file, and update imagePullSecrets section as:
```
imagePullSecrets:
  - name: intersystems-pull-secret
```

* Install IKO chart using `helm` in your AWS EKS cluster:
```
helm install intersystems iris_operator-3.3.0.120/chart/iris-operator
```

* After that, show running pods, you should see InterSystems IRIS Operator:
```
kubectl get pods
```

# Deploy IRIS in Kubernetes

## Create secrets
Define a secret for the IRIS license:
```
kubectl create secret generic iris-key-secret --from-file=iris.key
```

## Create iris-cpf config map
Create a config-map for configuration files:
```
kubectl create cm iris-cpf --from-file common.cpf --from-file data.cpf --from-file compute.cpf --from-file CSP.ini
```

## Storage
Define storage class:
```
kubectl apply -f storage.yaml
```

## Deploy
* Have a look at the [iris.yaml](k8s/iris.yaml) configuration.

* Deploy the InterSystems IRIS configuration:
``` 
kubectl apply -f iris.yaml
```

* Now, display running pods, services, etc:

```
kubectl get pods

kubectl get IrisClusters

kubectl get svc
```

# Run some tests

## Python client (NativeAPI)

Install nativeAPI (Python)
```
pip3 install nativeAPI_wheel/irisnative-1.0.0-cp34-abi3-linux_x86_64.whl 
```

Create an `client\ingest.ini` file and set up python client configuration like:
```
[iris]
ip = <ip>
port = 1972
namespace = IRISCLUSTER
username = superuser
password = <password>
```

Run the client:
```
Connected
Inserting data...
id = 139
id = 140
id = 141
id = 142
id = 143
...
```


# Delete Kubernetes deployment

After you have finished testing your deployment, you can delete it.

Go to k8s folder:
```
cd k8s
```

Delete the InterSystems IRIS deployment:
```
kubectl delete -f iris.yaml
```

Delete persistent volumes:
```
kubectl delete pvc $(kubectl get pvc -o name | cut -d/ -f2)
```

Delete iris service:
```
kubectl delete service iris-svc
```

Optionally, you can even uninstall IKO:
```
helm uninstall intersystems
```

And finally, delete the AWS EKS cluster: 
```
eksctl delete cluster --name afuentes-webinar-k8s-ha --region eu-west-1
```

