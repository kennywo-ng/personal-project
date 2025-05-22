==Deployment orders==
1. Start minikube (if local test)

2. Configmap and Secret must be created before deployment
- kubectl apply -f mongo-config.yaml
- kubectl apply -f mongo-secret.yaml

3. Create DB first before web app
- kubectl apply -f mongo.yml

4. Finally Web App
- kubectl apply -f webapp.yml

5. Port forward traffic from ec2 to minikube
- kubectl port-forward --address 0.0.0.0 svc/webapp-service 30100:3000

==command==
minikube start --driver docker
minikube status

kubectl get all
########################################################################################################
NAME                                    READY   STATUS                       RESTARTS   AGE
pod/mongo-deployment-7cccf8b6d8-8bzh6   1/1     Running                      0          57s
pod/webapp-deployment-9d86dc948-c7brq   0/1     CreateContainerConfigError   0          39s

NAME                     TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
service/kubernetes       ClusterIP   10.96.0.1        <none>        443/TCP          75m
service/mongo-service    ClusterIP   10.107.44.160    <none>        27017/TCP        57s
service/webapp-service   NodePort    10.110.194.247   <none>        3000:30100/TCP   39s

NAME                                READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/mongo-deployment    1/1     1            1           57s
deployment.apps/webapp-deployment   0/1     1            0           39s

NAME                                          DESIRED   CURRENT   READY   AGE
replicaset.apps/mongo-deployment-7cccf8b6d8   1         1         1       57s
replicaset.apps/webapp-deployment-9d86dc948   1         1         0       39s
#######################################################################################################

kubectl get node
kubectl get pod
kubectl get configmap
kubectl get secret
kubectl describe {{ anything from all }}
kubectl rollout restart deployment webapp-deployment
kubectl log pod/webapp-deployment-9d86dc948-c7brq
