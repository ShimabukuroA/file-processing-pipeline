### Base image for the other containers.
FROM openjdk:8-jre-slim

# Create folders for the shared volume
# Install python 3 , pip , wget and scala
RUN mkdir -p /opt/sandbox/data && \
    mkdir -p /opt/sandbox/src && \
    apt-get update && \
    apt-get install -y python3 python3-pip wget scala

ENV SCALA_HOME="/usr/bin/scala"
ENV PATH=${PATH}:${SCALA_HOME}/bin
ENV SHARED_VOLUME="/opt/sandbox"

VOLUME /opt/sandbox/

CMD ["bash"]