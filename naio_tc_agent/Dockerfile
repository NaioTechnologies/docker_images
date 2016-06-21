FROM debian:jessie

ENV AGENT_DIR  /opt/buildAgent

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		lxc iptables aufs-tools ca-certificates locales curl wget unzip git software-properties-common debootstrap sudo qemu syslinux extlinux gdb \
	&& rm -rf /var/lib/apt/lists/*

# Fix locale.
ENV LANG en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen && echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale

# Install java-8-oracle
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
	&& echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections \
	&& echo deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main > /etc/apt/sources.list.d/java-8-debian.list \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 \
	&& apt-get update \
  	&& apt-get install -y --no-install-recommends \
      oracle-java8-installer ca-certificates-java \
  	&& rm -rf /var/lib/apt/lists/* /var/cache/oracle-jdk8-installer/*.tar.gz /usr/lib/jvm/java-8-oracle/src.zip /usr/lib/jvm/java-8-oracle/javafx-src.zip \
      /usr/lib/jvm/java-8-oracle/jre/lib/security/cacerts \
  	&& ln -s /etc/ssl/certs/java/cacerts /usr/lib/jvm/java-8-oracle/jre/lib/security/cacerts \
  	&& update-ca-certificates

# Install docker
ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 1.10.1
ENV DOCKER_SHA256 2287bc5cbcd1cdad77f1c0c70c2b5b15f1d9c010900c3ffab059fb46fe81d141
RUN set -x \
  && curl -fsSL https://get.docker.com/ | sh \
  && docker -v

RUN adduser --disabled-password --gecos "" teamcity \
	&& sed -i -e "s/%sudo.*$/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/" /etc/sudoers \
	&& usermod -a -G docker,sudo teamcity

ADD docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

VOLUME /var/lib/docker
VOLUME /opt/buildAgent

EXPOSE 9090
