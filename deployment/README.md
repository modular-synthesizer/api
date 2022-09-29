# How to deploy

## Prerequisites

### Infrastructure

The application need the following components :
* A working Kubernetes cluster (you can provision one on [Scaleway](https://www.scaleway.com/) for example)
* A working MongoDB database and the corresponding connection string (hereafter named `<MONGODB_URL>`, containing username, password, host and database name). You can provision one on MongoDB Atlas for example.

### Kubernetes secrets

You MUST set a secret name `api` in the namespace `modusynth` containing the following values :
* `database-uri` having the value of `<MONGODB_URL>`

## Hosting

### Source versioning

Our application is currently versioned on Github but it is NOT mandatory to use Github as nothing is linked to a particular Git provider. However we strongly advice on using a Git repository to host the code for thousands of reasons you'll find online.

### DockerHUB

We use DockerHUB as a public Docker Trusted Registry (DTR) to store our images. We strongly advocate for the use of a public DTR as the application has NOT been tested on a private one. We authenticate on the DTR using username/password combination.

### CI/CD

Our CI/CD pipelines are executed on [CircleCI](https://www.circleci.com/) but it COULD be executed elsewhere. However we strongly advocate for the use of CircleCI as the whole pipeline is up and running in the `.circleci` folder.

If you plan on using CircleCI, you'll need to setup some environment variable in the project (see the CircleCI documentation to set environement variables in a project) :
* `DOCKER_USERNAME` your username to connect to the DTR
* `DOCKER_PASSWORD` the password you use to connect to the DTR
* `DOCKER_REPOSITORY` the name of the repository where the images will be stored.
* `KUBECONFIG_DATA` the base64-encoded content of the Kubernetes configuration to connect to your cluster.

The deployment on the production environment is NOT automatic as after the docker image is built you MUST validate it manually to deploy it on Kubernetes.

## Create a new image

You can use the Docker file to create a new image, just run the lines :

```
docker build -t <namespace>/<repository>:<tag> -f Dockerfile .
docker push <namespace>/<repository>:<tag>
```

Where :
* `namespace` is the namespace you're pushing in on the DTR (usually your username)
* `repository` is the name of the repository you're pushing in
* `tag` is the version of the API you're pushing in

## Deploying the image

When the image is built, you have to deploy it using three Kubernetes configuration files :
* `deployment.yml` to create new replicasets and ensure scalability and reliability on pods
* `service.yml` to create an internal load-balancer for these pods
* `ingress.yml` to be able to access this service from a designated route

You SHOULD replace the name of the image in the `deployment.yml` file.

If you use our CI/CD pipeline, keep the `<VERSION>` tag as it will be replaced by the last tag you pushed on your image on the DTR.