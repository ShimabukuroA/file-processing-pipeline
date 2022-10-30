#!/bin/bash

### Build base container image
echo "Building container base image..."
docker build \
-f builds/base-container/Dockerfile \
-t base_container:latest .

### Build JupyterLab image
echo "Building container image JupyterLab..."
docker build \
-f builds/jupyterlab/Dockerfile \
-t jupyterlab:latest .

### Build JupyterLab image
echo "Building container image JupyterLab..."
docker build \
-f builds/jupyterlab/Dockerfile \
-t jupyterlab:latest .

### Build Spark base image
echo "Building base container image Spark"
docker build \
-f builds/base-spark/Dockerfile \
-t base_spark:latest .

### Build Spark Master image
echo "Building container image Spark Master..."
docker build \
-f builds/spark-master/Dockerfile \
-t spark_master:latest .

### Build Spark Worker image
echo "Building container image Spark Worker..."
docker build \
-f builds/spark-worker/Dockerfile \
-t spark_worker:latest .