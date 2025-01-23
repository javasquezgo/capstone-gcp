
# Capstone Project - Marvin Rodriguez & Alejandro Vasquez

# URLS
- [GCE Instance](http://104.154.204.101/)

- [Cloud Run Instance](https://capstone-image-880123084956.us-central1.run.app/)

- [GKE Load Balancer's external IP address](http://146.148.46.34/)

- [App Engine address](https://sigfredom-dev.uc.r.appspot.com/)


A brief description of the bootcamp challenge

## 1. Start the website locally on Cloud Shell
a.) Open Cloud Shell

b.) Install git and docker if needed, using the following commands
    
``` 
sudo apt update

sudo apt install git

sudo apt install docker 
```

c.) Clone the Github project to have a local copy.

- Use the following command

 ```
 git clone https://github.com/GNiruthian/Europe-Travel-Website-html-css-js
 ```

d.) Create the Dockerimage file

- Use Use the following command

```
 nano Dockerfile
```

- On the newly created file, enter the following details

```
FROM nginx:latest
ARG src="Europe-Travel-Website-html-css-js/Europe Travel"
ARG target="/usr/share/nginx/html"
COPY ${src} ${target}
```

e.) Create a docker image using the Dockerfile

- Use the following command

```
docker build -t capstone-image ./
```

f.) Run the container using the new image created

- Use the following command

```
docker run -d -p 8080:80 capstone-image
```

g.) Test if the server is running

- Use the following command

```
curl http://localhost:8080
```

## 2. Push the image to Artifact Registry

a.) Once we’ve created a custom Docker image, we can upload it to the Artifact Registry, so it can be used on our project. To start, create an artifact repository if none exists.

- On your cloud console, go to the Artifact Registry section.
- Click "Create repository"
- Choose a name. For this project, the name "capstone-repository" has been used.
- Under format, choose "Docker" if not selected already.
- For this project, under "Location type", we choose "Multi-region", and we choose "us".
- Scroll to the bottom, and click Create.

b.) Once created, go back to the Cloud Shell, and rename the image using the following format:

- LOCATION-docker.pkg.dev/PROJECT-ID/REPOSITORY/IMAGE where:

```
    LOCATION is the region selected for the repository, in this case, we selected a multiregion in the US, so we’ll use us.
    
    PROJECT-ID is the ID of the project, for this exercise, we used sigfredom-dev.

    REPOSITORY is the Artifact Registry’s repository name. For this exercise we used capstone-repository.

    IMAGE is the image name. For this exercise we used capstone-image. 
```

- Once the name has been made, use the following command:

```
    docker tag SOURCE-IMAGE LOCATION-docker.pkg.dev/PROJECT-ID/REPOSITORY/IMAGE:TAG where
    
        SOURCE-IMAGE is the Image ID of the custom image made earlier. This can be obtained with the command docker image list

        TAG an optional parameter where you can set up a tag to better identify the image. If no tag is specified, docker will use the default value: latest.

Once renamed, use the following command to push the custom image to Artifact Registry:

    docker push LOCATION-docker.pkg.dev/PROJECT-ID/REPOSITORY/IMAGE.

Once completed, you can refresh the Artifact Registry repositories, and the custom image should be displayed and available.
```

## 3. Deploy the website using GCE

a.) On the Google Cloud Console go the to the Compute Engine section.

b.) Create a new VM instance.

```
Click on Create Instance.

For this project we chose an e2-medium type, and we named it capstone-gce-instance.

On the left, click on OS and storage.

Under Container click DEPLOY CONTAINER.

Under Container image, use the URL for the image uploaded to Artifact Registry, for 
this exercise, we used the image below:
        
        us-docker.pkg.dev/sigfredom-dev/capstone-repository/capstone-image@sha256:6a2690ad1f3337336eb38c6669a64c5ce3dede8c76d05d2a6d94435673f4886b

At the bottom, click Select
```

c.) Under Networking, make sure to check both Allow HTTP traffic and Allow HTTPS traffic.

d.) Click Create.

e.) Once created, you can access the website using the External IP address available on the VM instances list.

## 4. Deploy the website using Cloud Run

a.) On the Google Cloud Console, go to the Cloud Run section.

b.) Click Deploy Container, and choose Service.

c.) Choose Deploy one revision from an existing container image.

d.) Under Container image URL, click Select.

e.) Navigate to the Artifact Registry container, and choose the custom image we created earlier, and click Select.

f.) Choose a Service name. For this exercise, we used capstone-image

g.) Under Authentication, choose Allow unauthenticated invocations.

h.) Expand the section Container(s), Volumes, Networking, Security.

i.) Under Edit Container > Container port type the port 80.

j.) Click Done, then scroll down, and click Create.

k.) Once the service is running, you can click the URL available on the service details to access the website.

## 5. Deploy the website using GKE.

a.) On the Google Cloud Console, go to the Kubernetes Engine section.

b.) If needed, create a new Cluster.
```
On the left, click Clusters.

Click Create

Choose a name, region, and Cluster tier. For this exercise, we used the name 
capstone-gke-cluster, in the us-central1 region, with a Standard tier.

Click create.
```
c.) Once created, click on the cluster, and then click Deploy.

d.) Choose a Deployment name. For this exercise we used capstone-gke-deployment.

e.) If needed, choose the newly created cluster under Cluster.

f.) Click NEXT: CONTAINER DETAILS.

g.) Under New container, choose Existing container image, and click Select.
Navigate through the Artifact Registry Container, and locate the custom image that was created earlier.

i.) Click Select.

j.) Click NEXT: EXPOSE (OPTIONAL).

k.) Check Expose deployment as a new service.

l.) Under Port mapping choose Port 1 as port 80.

m.) Under Target port 1 choose the Port 80.

n.) Under Service type, choose Load balancer.

o.) Click Deploy.

p.) Once deployment is completed, you can click on the workload, and scroll down to Exposing services to find the endpoint IP address to access the website.

## 6. Deploy the website using App Engine.

a.) On the Google Cloud Console, go to the App Engine section.

b.) Click Create Application to initialize App Engine.

c.) Choose the Region and Service Account. For this exercise, we used the us-central region, and the App Engine default service account as the service account.

d.) Click Next.

e.) Once created, go back to the Cloud Shell instance we used prior.

f.) Use the following command to create a separate folder, and copy the HTML contents from the commit that was done earlier.
```
mkdir capstone-app-engine-settings

mv ‘./Europe-Travel-Website-html-css-js/Europe Travel’ ./capstone-app-engine-settings/www
```
g.) Create a yaml file with the app engine settings on the root folder for the app. For this exercise, that’ll be the capstone-app-engine-settings

Use the following commands

    cd capstone-app-engine-settings
    
    nano app.yaml

Enter the following details and save the file:
    
    runtime: python39

    handlers:
        - url: /
        static_files: www/index.html
        upload: www/index.html

        - url: /(.*)
        static_files: www/\1
        upload: www/(.*)

h.) Deploy the application

Use the following command

    gcloud app deploy


Once the deployment is finished use the command below to gather the URL to access the website.
    
    gcloud app browse



## Add SSH Key to connect Github account

a.) Open the terminal app on your computer

b.) Enter the following command, substituting youremail@example.com with your email address:

```
$ ssh-keygen -t rsa -b 4096 -C "youremail@example.com"
```

c.) Press Enter to accept the default file location.

d.) Enter a secure passphrase.

e.) Press Enter.

f.) Enter this command to display the contents of your public key:
```
$ cat .ssh/id_rsa.pub
```

g.) Copy the contents of your key to your clipboard (we will need it later).

h.) Log into your GitHub account and Click your avatar and choose Settings.

i.) Select SSH and GPG keys.

j.) Click New SSH key.

k.) Enter a title in the field and Paste your public key into the Key field.

l.) Click Add SSH key.

