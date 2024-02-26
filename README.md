# PC-Def-Daemonset-Updater

A project to develop a solution to update automatically the Prisma Cloud Daemonset Defender

**Note: Fork or clone this project in your own environment to start the lab.**

In this repo it's assumed that you have any earlier version of Prisma Cloud Defender (Daemonset) deployed in your K8S Cluster. In this use case we use _'twistlock'_ namespace like in defender YAML template (by default).

## Solution Architecture

In this solution it's used K8S core resources like: CronJob, ServiceAccount, Role, RoleBinding, Volume, ConfigMap, etc... A brief look of the solution is:

![DefenderUpdater Diagram](./images/Solution'sDiagram.jpg)

## Building & Publishing Docker Image

1. Open Terminal and Go to the directory where you clone this repository.

2. Build the Docker Image with **kubectl** tool to execute the Daemonset update.

   ```
   docker build -t alpine-kubectl:1.0 .
   ```

3. Verify that docker image contains kubectl tool installed.

   ```
   docker run alpine-kubectl:1.0 version --client
   ```

4. Login to Docker Hub with your credentials.

   ```
   docker login
   ```

5. Publish your Docker Image in your Docker Hub repository.

   ```
   docker tag alpine-kubectl:1.0 "yourUsername"/alpine-kubectl:1.0
   docker push "yourUsername"/alpine-kubectl:1.0
   ```

Note: If you want you can use the pre-builded docker image located in DockerHub repo: bsantacruz/alpine-kubectl

## Deploying Updater into K8S Cluster

1. Connect to your cluster and create the RBAC resources needed to interact with daemonsets in 'twistlock' namespace.

   ```
   kubectl create -f RBAC.yaml -n twistlock
   ```

2. Verify that Service Account has correct permissions to interact with daemonsets.

   ```
   kubectl auth can-i --as=system:serviceaccount:twistlock:defender-updater-sa get daemonsets.apps -n twistlock
   ```

3. Create the ConfigMap resource, this contains data script to execute by the Cronjob.

- Open `./DefenderUpdater.sh` file and set the variables DAEMONSET_NAME & CONTAINER_NAME with your values (first command below), copy all content file.
- Replace ConfigMap data section with the content copied above, adjust the format.
- To avoid error give execution permissions to `./DefenderUpdater.sh` script file.

  ```
  # Find defender resources created in twistlock namespace:
  kubectl get all -n twistlock
  # Give execution permissions:
  sudo chmod +x DefenderUpdater.sh
  # Create ConfigMap from yaml template:
  kubectl create -f ConfigMap.yaml -n twistlock
  # Alternative you can use imperative command to create ConfigMap:
  kubectl create configmap defender-updater-script-configmap --from-file=DefenderUpdater.sh
  ```

4. Modify & create the CronJob resource.

- Open the `./CronJob.yaml` file and modify parameters like _'spec.schedule, .spec.containers.image and any others you requires'_

  ```
  kubectl create -f CronJob.yaml -n twistlock
  ```

5. If you want to test manually the CronJob without wait to schedule, you can create a Job.

   ```
   kubectl create job --from=cronjob/defender-updater defender-updater-job -n twistlock
   ```

6. To monitor & view logs of the executions you can locate the job and view status which must be "completed"

   ```
   # Review completions and status respectively:
   kubectl get jobs -n twistlock
   kubectl get pods -n twistlock

   # Locate the job pod with prefix 'defender-updater-job-xxxxx' and review it:
   kubectl describe pod defender-updater-job -n twistlock

   # Review events for CronJob:
   kubectl describe cronjob defender-updater -n twistlock
   ```

7. To view events associated to CronJob.

   ```
   kubectl describe cronjob defender-updater -n twistlock
   ```

   **Note: By default there are 3 successful Job executions & 1 failed Job execution maintained in history.**

8. To view defender daemonset annotations & events. Take into account that daemonset has **'kubernetes.io/change-cause'** annotation with time of execution.

   ```
   kubectl describe daemonset twistlock-defender-ds -n twistlock
   ```

### ¡Be careful if you change resources names & content of scripts!
