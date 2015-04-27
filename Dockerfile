FROM ubuntu:14.04
MAINTAINER Jakob Homan <jghoman@gmail.com>

RUN apt-get update

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

# Install other dev-related items
RUN apt-get install -y \
  ant \
  autoconf \
  build-essential \
  curl \
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

RUN curl -sSL "ftp://mirror.reverse.net/pub/apache/maven/maven-3/3.3.1/binaries/apache-maven-3.3.1-bin.tar.gz" | tar -xz -C /usr/local/bin \
  && ln -s /usr/local/bin/apache-maven-3.3.1/bin/mvn /usr/local/bin/mvn

env M2_HOME /usr/local/bin/apache-maven-3.3.1

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
