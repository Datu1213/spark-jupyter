FROM quay.io/jupyter/minimal-notebook:python-3.13

# Labels for metadata
LABEL maintainer="zhenkuiwang1213@gmail.com"
LABEL description="Jupyter Notebook with PySpark"
LABEL version="1.0.0"

# ---
# Define version of Java and Spark
# Cover it using --build-arg JAVA_VERSION=11
ARG JAVA_VERSION=17
ARG SPARK_VERSION=3.5.7

USER root

# 安装 Java 和 PySpark
RUN apt-get update && \
    # --------  Important  ------------
    # Use headless JDK to avoid ument depandencies exceptions
    # --------  Important  ------------
    apt-get install -y --no-install-recommends openjdk-${JAVA_VERSION}-jdk-headless && \
    pip install --no-cache-dir pyspark==${SPARK_VERSION} pandas numpy matplotlib && \
    # --------------------
    # If you need additional system libraries, add them here
    # Example: apt-get install -y --no-install-recommends openjdk-${JAVA_VERSION}-jdk-headless vim curl && \
    # Clean cache to reduce image size
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER jovyan

# ---
# Set Java environment variables
# 'headless'
ENV JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# ---
# Set Spark master URL
ENV SPARK_MASTER=spark://spark-master:7077
# ENV SPARK_MASTER=local[*]

# Tell PySpark Driver and Executors to use Python3
ENV PYSPARK_DRIVER_PYTHON=python3
ENV PYSPARK_PYTHON=python3

# Enable JupyterLab interface
ENV JUPYTER_ENABLE_LAB=yes

ENV HOME=/home/jovyan

# Set Spark configuration directory
ENV SPARK_CONF_DIR=/home/jovyan/spark-conf

# EXpose Jupyter Notebook port
EXPOSE 8888

