#!/bin/bash
set -e
sudo service ssh start

if [ ! -d "/tmp/hadoop-hduser/dfs/name" ]; then
        $HADOOP_HOME/bin/hdfs namenode -format && echo "OK : HDFS namenode format operation finished successfully !"
fi

$HADOOP_HOME/sbin/start-dfs.sh

echo "YARNSTART = $YARNSTART"
if [[ -z $YARNSTART || $YARNSTART -ne 0 ]]; then
        echo "running start-yarn.sh"
        $HADOOP_HOME/sbin/start-yarn.sh
fi



$HADOOP_HOME/bin/hdfs dfsadmin -safemode leave

# keep the container running indefinitely
# tail -f $HADOOP_HOME/logs/hadoop-*-namenode-*.log
rm -rf /root/.bash_history;

while true
do
  /usr/sbin/sshd -D
done
