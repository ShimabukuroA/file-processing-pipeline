### Base image for Spark.
FROM base_container

# Install Spark binary.
RUN wget https://archive.apache.org/dist/spark/spark-3.3.0/spark-3.3.0-bin-hadoop3.tgz \
    && tar -xf spark-3.3.0-bin-hadoop3.tgz \
    && mv spark-3.3.0-bin-hadoop3 /usr/bin/

ENV SPARK_HOME /usr/bin/spark-3.3.0-bin-hadoop3
ENV SPARK_MASTER_HOST spark-master
ENV SPARK_MASTER_PORT 7077
ENV SPARK_MASTER_WEBUI_PORT 8080
ENV PYSPARK_PYTHON /usr/bin/python3

CMD ["bash"]