### Image for Spark worker
FROM base_spark

# Expose port for Worker Node.
EXPOSE 8081

ENTRYPOINT /usr/bin/spark-3.3.0-bin-hadoop3/bin/spark-class org.apache.spark.deploy.worker.Worker $MASTER_PORT_7077_TCP_ADDR:$MASTER_PORT_7077_TCP_PORT