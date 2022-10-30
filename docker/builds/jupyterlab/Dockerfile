### Image for Jupyterlab.
FROM base_container

# Define path for Shared Volume.
WORKDIR $SHARED_VOLUME

# Install Pyspark and Jupyterlab packages.
RUN pip3 install pyspark==3.3.0 \
    jupyterlab==3.5.0

# Expose port 8888 for JupyterLab.
EXPOSE 8888

CMD jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=''