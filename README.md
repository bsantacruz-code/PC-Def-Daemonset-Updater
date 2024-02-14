# PC-Def-Daemonset-Updater

A project to develop a solution to update automatically the Prisma Cloud Daemonset Defender

## Building & Publishing Docker Image

1. Open Terminal and Go to the directory where you have this repository.

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
