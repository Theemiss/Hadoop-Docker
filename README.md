# Holberton School Hadoop Env Checker

Enviroment used to test the haddop Project in the Holberton School. 


## Usage/Examples

In order to build a fresh container you need to navigate to the app directory and type:
### Build
```bash
docker build . --no-cache --force-rm --tag <container_tag>
```

### Run
Now that we have a fresh container that we can working with we can run it using this command:
```bash
docker run --name <container-name> -p 9864:9864 -p 9870:9870 -p 8088:8088 -p 9000:9000 --hostname <your-hostname> hadoop
```
Change **container-name** by your favorite name and set **your-hostname** with by your ip or name machine.

To run it interactively you can use this command:
```bash
$ docker exec  -it <container_name>  /bin/bash
hduser@myhdf:~$ 
```


To check if hadoop container is working:

- go to the url in your browser: http://localhost:9870
- use hdfs bin from outside the host `docker cp <container-name>:/home/hduser/hadoop-3.3.3/bin/hdfs .` and try a mkdir `./hdfs dfs -mkdir hdfs://localhost:9000/tmp`

### Examples

## A first example

Make the HDFS directories required to execute MapReduce jobs:
```bash

     hduser@myhdfs:~$ hdfs dfs -mkdir /user
     hduser@myhdfs:~$ hdfs dfs -mkdir /user/hduser
```

Copy the input files into the distributed filesystem:
```bash      
     hduser@myhdfs:~$ hdfs dfs -mkdir input
     hduser@myhdfs:~$ hdfs dfs -put $HADOOP_HOME/etc/hadoop/*.xml input

```


## Authors

- [@Ahmed Belhaj](https://github.com/Theemiss)
