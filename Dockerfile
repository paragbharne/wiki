FROM ubuntu:14.04
MAINTAINER Parag Bharne

ENV CONF_HOME     /opt/confluence

RUN apt-get update && apt-get -y upgrade && apt-get -y install wget nano git sed

RUN apt-get -y  install mysql-client
RUN apt-get -y  install default-jre default-jdk

RUN apt-get -y install software-properties-common python-software-properties
#RUN add-apt-repository -y  ppa:webupd8team/java
#RUN apt-get update
#RUN apt-get -y install oracle-java7-installer


RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer


RUN mkdir /opt/confluence

WORKDIR /opt/confluence

RUN wget https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-6.0.1.tar.gz

RUN tar -xvf atlassian-confluence-6.0.1.tar.gz --strip-components=1

RUN rm -rf atlassian-confluence-6.0.1.tar.gz

#ADD server.xml /opt/confluence/conf/

#RUN sed -i "s/Xms1024m/Xms128m/g" "/opt/confluence/confluence/bin/setenv.sh"
WORKDIR /home

RUN echo "confluence.home=/data" > /opt/confluence/confluence/WEB-INF/classes/confluence-init.properties

VOLUME /data

RUN wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.40.tar.gz

RUN tar -xvf mysql-connector-java-5.1.40.tar.gz

RUN cp  mysql-connector-java-5.1.40/mysql-connector-java-5.1.40-bin.jar /opt/confluence/confluence/WEB-INF/lib/

RUN rm -rf mysql-connector-java-5.1.40

RUN rm -rf mysql-connector-java-5.1.40.tar.gz

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

EXPOSE 8090
WORKDIR /opt/confluence

#entrypoint sudo service confluence restart &&  bash

ENTRYPOINT /opt/confluence/bin/start-confluence.sh && sleep 3600

