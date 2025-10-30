# spark-jupyter
A minimal easy-to-run Jupyter notebook server  for data scientists and engineer working with Spark 3.5.7
Java Env, pyspark, pyhton, numpy, pandas are ready to use.
# Image
```
ghcr.io/datu1213/spark-jupyter:python3.13-java17-pyspark3.5.7
```
# Reminder
- Use path like `/opt/spark/data/xxxxx`, cause Jupyter Server is just a server tool, real manipulations run on Spark Workers.
- Use `user: "${UID}:${GID}"` in `docker-compose.yml` to avoid permission problem.
# Environment variables
## environment variables
### Customizable environment variables
|Name|Description|Default Value|
|-|-|-|
|**`SPARK_MASTER`**|Spark master url|**`spark://spark-master:7077`**|
|**`JUPYTER_ENABLE_LAB`**|Whether to use new Jupyter interface or not|**`yes`**|
|**`SPARK_CONF_DIR`**|Spark conf dir(**Use the same volume with spark-master and spark-workers in docker-compose.yaml**)|**`/home/jovyan/spark-conf`**|

# Usage
### docker
```bash
docker pull ghcr.io/datu1213/spark-jupyter:python3.13-java17-pyspark3.5.7
```

### docker-compose.yaml

```yaml
spark-jupyter:
  # Ues build to customize Java and Spark version
  # build:
  #   context: ./spark-jupyter
  #   args:
  #     JAVA_VERSION: 17
  #     SPARK_VERSION: 3.5.7
  image: spark-jupyter:1.0.0
  depends_on:
    - spark-worker
  ports:
    - "8888:8888" # Jupyter Notebook UI
  volumes:
  # Best practices: Share the data, every things shows in your Jupyter notebook.
  # Use read-only mode if needed.
    - ./spark-notebooks:/home/jovyan/work
    - ./spark-data:/home/jovyan/data
    - ./spark-warehouse:/home/jovyan/warehouse
    - ./metastore_db:/home/jovyan/metastore_db
    - ./ivy2:/home/jovyan/.ivy2:ro
    - ./config/spark-defaults.conf:/home/jovyan/spark-conf/spark-defaults.conf
  environment:
    JUPYTER_TOKEN: "mysecrettoken" # Jupyter Notebook Authentication Token
    # Not SPARK_MASTER_URL
    SPARK_MASTER: spark://spark-master:7077
```