# Deploying a Flask API

This is the project starter repo for the course Server Deployment, Containerization, and Testing.

In this project you will containerize and deploy a Flask API to a Kubernetes cluster using Docker, AWS EKS, CodePipeline, and CodeBuild.

The Flask app that will be used for this project consists of a simple API with three endpoints:

- `GET '/'`: This is a simple health check, which returns the response 'Healthy'. 
- `POST '/auth'`: This takes a email and password as json arguments and returns a JWT based on a custom secret.
- `GET '/contents'`: This requires a valid JWT, and returns the un-encrpyted contents of that token. 

The app relies on a secret set as the environment variable `JWT_SECRET` to produce a JWT. The built-in Flask server is adequate for local development, but not production, so you will be using the production-ready [Gunicorn](https://gunicorn.org/) server when deploying the app.

## Initial setup
1. Fork this project to your Github account.
2. Locally clone your forked version to begin working on the project.

## Dependencies

- Docker Engine
    - Installation instructions for all OSes can be found [here](https://docs.docker.com/install/).
    - For Mac users, if you have no previous Docker Toolbox installation, you can install Docker Desktop for Mac. If you already have a Docker Toolbox installation, please read [this](https://docs.docker.com/docker-for-mac/docker-toolbox/) before installing.
 - AWS Account
     - You can create an AWS account by signing up [here](https://aws.amazon.com/#).
     
## Project Steps

Completing the project involves several steps:

1. [x] Write a Dockerfile for a simple Flask API
2. [x] Build and test the container locally
3. [ ] Create an EKS cluster
4. [ ] Store a secret using AWS Parameter Store (unit 25)
5. [ ] Create a CodePipeline pipeline triggered by GitHub checkins
6. [ ] Create a CodeBuild stage which will build, test, and deploy your code

For more detail about each of these steps, see the project lesson.

## CodePipeline : Additional Information
You can find additional information about CodePipeline here. For more information on CloudFormation templates see: [Working with CloudFormation Templates](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-guide.html).

When you create a CodePipeline pipeline you should do so in the context of a CloudFormation stack. CloudFormation is a service for managing the creation of Amazon resources. Resources created together are grouped in a stack. This makes it easy to see related resources in the CloudFormation console.

CloudFormation stacks are defined in template files, (.yml). These files define all of the resources for your stack. CloudFormation templates contain sections for resources used in a stack and parameters to be set when the stack is created.

A great way to get started with CloudFormation is to use one of the [sample templates](https://aws.amazon.com/cloudformation/aws-cloudformation-templates/). There are instructions for trying a sample template here. This walks you through using a sample template to setup and tear down the resources necessary to run a WordPress site.

Soon, you will see a template file ci-cd-codepipeline.cfn.yml in the project lesson.


## CodeBuild : Additional Resources
* General information about CodeBuild can be found [here](https://aws.amazon.com/codebuild/).

* AWS instructions on how to create a pipeline with CodeBuild and CodePipeline can be found [here](https://docs.aws.amazon.com/codebuild/latest/userguide/how-to-create-pipeline.html).

* Documentation on Buildspec files can be found [here](https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html).

The instructions that a CodeBuild stage will follow are put in a build spec file named buildspec.yml. This file contains all of the commands that the build will run and any related settings. This file should be placed at the root of your project directory. Amazon supplies [CodeBuild samples](https://docs.aws.amazon.com/codebuild/latest/userguide/samples.html), you can see examples of build spec files there. The sample for a simple Docker custom image has the build spec:
```
version: 0.2

phases:
  install:
    commands:
      - nohup /usr/local/bin/dockerd --host=unix:///var/run/docker.sock --host=tcp://127.0.0.1:2375 --storage-driver=overlay2&
      - timeout 15 sh -c "until docker info; do echo .; sleep 1; done"
  pre_build:
    commands:
      - docker build -t helloworld .
  build:
    commands:
      - docker images
      - docker run helloworld echo "Hello, World!" 
``` 

You can see that it is divided into the phases ‘install’, ‘pre_build’, and ‘build’. Each phase contains commands, which are the same commands you would use to run Docker locally. You can read about the build spec syntax [here](https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html#build-spec-ref-syntax).
































