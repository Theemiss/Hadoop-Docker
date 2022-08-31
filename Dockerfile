FROM ubuntu:20.04

RUN apt-get update -y \
    && export DEBIAN_FRONTEND=noninteractive && apt-get install -y --no-install-recommends \
        software-properties-common \
        sudo \
        wget \
        openssh-server  \
        openssh-client \
        curl \
    && apt-get clean

RUN apt-get update  -y \
  && apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 --no-cache-dir install --upgrade pip \
  && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:openjdk-r/ppa
RUN apt-get update && apt-get install -y openjdk-8-jdk && apt-get install -y wget && rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

RUN pip3 install snakebite-py3
RUN useradd -m hduser && echo "hduser:supergroup" | chpasswd && adduser hduser sudo && echo "hduser     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && cd /usr/bin/ && sudo ln -s python3 python
COPY ssh_config /etc/ssh/ssh_config


WORKDIR /home/hduser
USER hduser
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && chmod 0600 ~/.ssh/authorized_keys
ENV HADOOP_VERSION=3.3.2
ENV HADOOP_HOME /home/hduser/hadoop-${HADOOP_VERSION}
RUN curl -sL --retry 3 \
  "http://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" \
  | gunzip \
  | tar -x -C /home/hduser/ \
 && rm -rf ${HADOOP_HOME}/share/doc

ENV HDFS_NAMENODE_USER hduser
ENV HDFS_DATANODE_USER hduser
ENV HDFS_SECONDARYNAMENODE_USER hduser

ENV YARN_RESOURCEMANAGER_USER hduser
ENV YARN_NODEMANAGER_USER hduser

RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh
COPY core-site.xml $HADOOP_HOME/etc/hadoop/
COPY hdfs-site.xml $HADOOP_HOME/etc/hadoop/
COPY yarn-site.xml $HADOOP_HOME/etc/hadoop/

COPY docker-entrypoint.sh $HADOOP_HOME/etc/hadoop/
RUN chmod u+x $HADOOP_HOME/etc/hadoop/docker-entrypoint.sh


ENV PATH $PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin


EXPOSE 50070 50075 50010 50020 50090 8020 9000 9864 9870 10020 19888 8088 8030 8031 8032 8033 8040 8042 22

WORKDIR /usr/local/bin
RUN sudo ln -s ${HADOOP_HOME}/etc/hadoop/docker-entrypoint.sh .
WORKDIR /home/hduser

# YARNSTART=0 will prevent yarn scheduler from being launched
ENV YARNSTART 0

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]


