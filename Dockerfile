FROM ubuntu:14.04
MAINTAINER Jakob Homan <jghoman@gmail.com>

RUN apt-get update && apt-get install -y curl

# Install so many JDKs
RUN apt-get -y install software-properties-common \
  && add-apt-repository ppa:webupd8team/java -y \
  && apt-get update \
  && (echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections) \
  && apt-get install --no-install-recommends -y oracle-java6-installer \
  && apt-get install --no-install-recommends -y oracle-java7-installer \
  && apt-get install --no-install-recommends -y oracle-java8-installer \
  && apt-get install --no-install-recommends -y oracle-java7-set-default

ENV JAVA6_HOME /usr/lib/jvm/java-6-oracle
ENV JAVA7_HOME /usr/lib/jvm/java-7-oracle
ENV JAVA8_HOME /usr/lib/jvm/java-8-oracle
ENV JAVA_HOME $JAVA7_HOME

# Maven
RUN curl -sSL "ftp://mirror.reverse.net/pub/apache/maven/maven-3/3.3.1/binaries/apache-maven-3.3.1-bin.tar.gz" | tar -xz -C /usr/local/bin \
  && ln -s /usr/local/bin/apache-maven-3.3.1/bin/mvn /usr/local/bin/mvn

# Scalas
RUN (curl -sSL "http://www.scala-lang.org/files/archive/scala-2.9.3.tgz" | tar -xz -C /usr/local/bin) \
  && (curl -sSL "http://downloads.typesafe.com/scala/2.10.5/scala-2.10.5.tgz" | tar -xz -C /usr/local/bin) \
  && (curl -sSL "http://downloads.typesafe.com/scala/2.11.6/scala-2.11.6.tgz" | tar -xz -C /usr/local/bin) \
  && ln -s /usr/local/bin/scala-2.11.6/bin/scala /usr/local/bin/scala

ENV SCALA211_HOME=/usr/local/bin/scala-2.11.6
ENV SCALA210_HOME=/usr/local/bin/scala-2.10.5
ENV SCALA29_HOME=/usr/local/bin/scala-2.9.3
ENV SCALA_HOME=$SCALA211_HOME/


# Install other dev-related items
RUN apt-get install -y \
  ant \
  autoconf \
  build-essential \
  erlang \
  ghc \
  git \
  htop \
  llvm \
  ncdu \
  pandoc \
  python \
  silversearcher-ag \
  tig \
  tree \
  vim \
  vim-doc

# TODO: protobuf and gradle

# Run as a regular user for now own
ENV ME jghoman

RUN useradd --create-home $ME \
  && chown -R $ME:$ME /home/$ME

USER $ME
WORKDIR /home/$ME

VOLUME $HOME/repos
VOLUME $HOME/.m2

# Install my configs and dot files
RUN git clone https://github.com/jghoman/dotfiles.git \
  && git -C dotfiles pull \
  && dotfiles/scripts/install.sh

# Define default command.
CMD ["bash"]
