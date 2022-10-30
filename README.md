# File Processing Pipeline

### Table of Contents

1. [Introduction](#introduction)
2. [Backlog of Tasks](#backlog)
3. [Solution](#solution)
    - [High Level Design Solution](#hld)
    - [Overview](#overview)
    - [Develop environment](#env)
4. [Implementation](#implementation)
    - [Create the Docker images](#create)
    - [Build the Docker images](#build)
    - [Start containers](#start)
    - [Spark job](#job)
5. [How to run](#how2run)
6. [References](#references)

## TL;DR
### How to run:
1. You will need Docker installed in your machine. You also need to be able to run shell scripts and docker/docker-compose command line.
2. Clone the repo:  
```git clone https://github.com/ShimabukuroA/file-processing-pipeline.git```
3. Build the Docker images(you may need to give execution permission to execute this shell). It may take a few minutes.  
```cd docker && sh build_container_image.sh```  
4. Run the containers. Wait until all the containers are started.  
```docker-compose up -d```  
5. Open you browser and access the URL **localhost:8888** to see the JupyterLab interface
6. Inside the folder /src/ is the notebook file_processing.ipynb with the job code.  
7. Run the cells in sequence to perform the process. At the end, you will see the ouput files in the folder /data/output.
8. You can see the job resources in the cluster UI at **localhost:8080**.


## Introduction <a name="introduction"></a>

The content of this repository has the purpose to demonstrate a solution to perform a processing of events that are stored in files described in Pismo Data Engineer Challenge.  
For the proposed scenario, we expect that each event follow a well-defined schema described bellow. Here is an example of event payload that our pipeline is going to process:

```json
{
    "event_id": "3aaafb1f-c83b-4e77-9d0a-8d88f9a9fa9a",
    "timestamp": "2021-01-14T10:18:57",
    "domain": "account",
    "event_type": "status-change",
    "data": {
        "id": 948874,
        "old_status": "SUSPENDED",
        "new_status": "ACTIVE",
        "reason": "Natus nam ad minima consequatur temporibus."
    }
}

```
The following table describes each field from the payload:
| Field | Description |
|------------|-------------|
| event_id   |Unique identifier for each event.|
| timestamp  |Timestamp for event generation.|
| domain     |A classifier for the event.|
| event_type |A classifier for the event. <br> A combination of fields **domain + data** represents a unique event type.|
| data       |Payload from event itself. A field **id** present inside is a unique identifier for a domain value represented in field **domain**.|

We are a going to process a sample of events dumped in files and write to an output partitioned by event type and timestamp(year, month and day).

## Backlog of Tasks <a name="backlog"></a>

The following table list tasks to do for the project.
| ID | Description | Status | Commit |
|------------|-------------|-------------|-------------|
|TASK-01|High Level Design for the solution|<mark>**DONE**</mark>|[Commit link](https://github.com/ShimabukuroA/file-processing-pipeline/commit/cbe75647bda48033f6356213299a8b3d85d84e9f)|
|TASK-02|Implement Docker environment to run the job|<mark>**DONE**</mark>|[Commit link](https://github.com/ShimabukuroA/file-processing-pipeline/commit/ac1638224eeaf80a266fcd7cb902b3c0d9ef5c6c)|
|TASK-03|Implement the Pyspark job|<mark>**DONE**</mark>|[Commit link](https://github.com/ShimabukuroA/file-processing-pipeline/commit/63d9ec48f20b7f4ea9ae5ced9bd5f27ac9374f9c)|
|TASK-04|Finish documentation|<mark>**DONE**</mark>|[Commit link](https://github.com/ShimabukuroA/file-processing-pipeline/commit/1a94ddae681164a2a3b23e4f742b3f245b7c74e9)|

## Solution <a name="solution"></a>

### High Level Design Solution <a name="hld"></a>
![Alt text](https://github.com/ShimabukuroA/file-processing-pipeline/blob/develop/docs/hld_solution.svg)

### Overview <a name="overview"></a>
The solution consists of 3 components:
- JupyterLab interface
- Spark cluster
- Shared volume

The components will be created within a Docker environment where source code and data will be mounted in a shared volume(1) where JupyterLab and Spark cluster(3) can access from it. JupyterLab will be an interface to access Spark cluster using Pyspark code(2).

### Develop environment <a name="env"></a>
This section describes the environment where the solution was developed.  
To run this solution we are only using Docker Engine and Docker compose. Bellow is described the local machine configs we are using to develop/test and the Docker version.
```
Operating System: Ubuntu 18.04.5 LTS
Kernel: Linux 4.15.0-194-generic
Architecture: x86-64

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 142
model name      : Intel(R) Core(TM) i7-8550U CPU @ 1.80GHz
stepping        : 10
microcode       : 0xf0
cpu MHz         : 2700.098
cache size      : 8192 KB
physical id     : 0
siblings        : 8
core id         : 0
cpu cores       : 4
```

```
Client: Docker Engine - Community
 Version:           20.10.3
 API version:       1.41
 Go version:        go1.13.15
 Git commit:        48d30b5
 Built:             Fri Jan 29 14:33:13 2021
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true

Server: Docker Engine - Community
 Engine:
  Version:          20.10.3
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.13.15
  Git commit:       46229ca
  Built:            Fri Jan 29 14:31:25 2021
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.4.3
  GitCommit:        269548fa27e0089a8b8278fc4fc781d7f65a939b
 runc:
  Version:          1.0.0-rc92
  GitCommit:        ff819c7e9184c13b7c2607fe6c30ae19403a7aff
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0


Docker Compose version v2.12.2
```

## Implementation <a name="implementation"></a>
This section describes how the Docker envrionment is built with custom images that are used to deploy the containers.
### Create the docker images <a name="create"></a>
We will create 5 images to deploy the Docker environment using Docker Compose:
- **Base image**: This image is a simple linux distribution with Java 8, Python3, Pip and Scala installed. We also create a volume that will be shared with all containers.
- **JupyterLab image**: We use base image to build this image. Install and configure the JupyterLab IDE along with the Pyspark package.
- **Spark base image**: We use base image to build this image. Install and configure Spark 3.3.0 version.
- **Spark Master**: We use Spark base image to build this image. Export the ports of Web UI and master node. Set the entrypoint for the master class.
- **Spark Worker**: We use Spark base image to build this image. Export the ports of worker node. Set the entrypoint for the worker class.  

The following code snippets show the Dockerfile for the images described.

#### Base image
https://github.com/ShimabukuroA/file-processing-pipeline/blob/942997736b5218f573e5e2372f909a49fd04388f/docker/builds/base-container/Dockerfile#L1-L17
#### JupyterLab image
https://github.com/ShimabukuroA/file-processing-pipeline/blob/942997736b5218f573e5e2372f909a49fd04388f/docker/builds/jupyterlab/Dockerfile#L1-L14
#### Spark base image
https://github.com/ShimabukuroA/file-processing-pipeline/blob/942997736b5218f573e5e2372f909a49fd04388f/docker/builds/base-spark/Dockerfile#L1-L15
#### Spark master image
https://github.com/ShimabukuroA/file-processing-pipeline/blob/942997736b5218f573e5e2372f909a49fd04388f/docker/builds/spark-master/Dockerfile#L1-L7
#### Spark worker image
https://github.com/ShimabukuroA/file-processing-pipeline/blob/942997736b5218f573e5e2372f909a49fd04388f/docker/builds/spark-worker/Dockerfile#L1-L7

### Build the Docker images <a name="build"></a>
A shell script was developed to build all images at once.
https://github.com/ShimabukuroA/file-processing-pipeline/blob/6e494533a82c0e6922e46a8350ca84cfe7e603a6/docker/build_containers_image.sh#L1-L37

### Start containers <a name="start"></a>
The Docker compose file describes how to deploy the containers. We will create the JupyterLab and Spark cluster containers, define and expose their ports for network connection and share the volume between them.  
https://github.com/ShimabukuroA/file-processing-pipeline/blob/6e494533a82c0e6922e46a8350ca84cfe7e603a6/docker/docker-compose.yml#L1-L47

### Spark job <a name="job"></a>
With our JupyterLab IDE and Spark cluster up, we can run a pyspark job to process some data. A notebook was developed to guide through the steps that the job performs to process the events.  
The notebook's source code is located in **docker/src folder** in this repo.

## How to run <a name="how2run"></a>
1. You will need Docker installed in your machine. You also need to be able to run shell scripts and docker/docker-compose command line.
2. Clone the repo:  
```git clone https://github.com/ShimabukuroA/file-processing-pipeline.git```
3. Build the Docker images(you may need to give execution permission to execute this shell). It may take a few minutes.  
```cd docker && sh build_container_image.sh```  
4. Run the containers. Wait until all the containers are started.  
```docker-compose up -d```  
5. Open you browser and access the URL **localhost:8888** to see the JupyterLab interface
6. Inside the folder /src/ is the notebook file_processing.ipynb with the job code.  
7. Run the cells in sequence to perform the process. At the end, you will see the ouput files in the folder /data/output.
8. You can see the job resources in the cluster UI at **localhost:8080**.

## References <a name="references"></a>
- [Window Functions - Pypark](https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.Window.html)
- [Apache Spark](https://spark.apache.org/docs/3.3.0/)
- [Creating Spark cluster with Docker](https://dev.to/mvillarrealb/creating-a-spark-standalone-cluster-with-docker-and-docker-compose-2021-update-6l4)
- [Dockerizing Jupyter Projects](https://towardsdatascience.com/dockerizing-jupyter-projects-39aad547484a)