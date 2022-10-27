### Image for Spark master.
FROM base_spark

# Expose ports for Web UI and Master node.
EXPOSE 8080 7077

ENTRYPOINT ["/usr/bin/spark-3.3.0-bin-hadoop3/bin/spark-class","org.apache.spark.deploy.master.Master"]