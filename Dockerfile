
# Originally derived from: 
# Oracle Java 8 Dockerfile
#
# https://github.com/dockerfile/java
# https://github.com/dockerfile/java/tree/master/oracle-java8
#

# Pull base image.
FROM ubuntu:14.04
MAINTAINER Jakob Homan <jghoman@gmail.com>

RUN apt-get update
RUN apt-get -y upgrade
#RUN apt-get -y install software-properties-common
RUN sudo apt-get -y install software-properties-common
RUN add-apt-repository ppa:webupd8team/java -y
RUN apt-get update

RUN (echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections)
RUN apt-get install -y oracle-java8-installer oracle-java8-set-default

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Define default command.
CMD ["bash"]
