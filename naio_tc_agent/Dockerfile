FROM jetbrains/teamcity-minimal-agent

ENV AGENT_DIR  /opt/buildagent
 
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		lxc iptables aufs-tools ca-certificates locales curl wget unzip git software-properties-common debootstrap sudo qemu syslinux extlinux gdb less nano build-essential python bc gcc-multilib\
	&& rm -rf /var/lib/apt/lists/*


RUN echo Europe/Paris > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata \
    && locale-gen en_US.UTF-8

# Install docker
ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 1.12.0
ENV DOCKER_SHA256 2287bc5cbcd1cdad77f1c0c70c2b5b15f1d9c010900c3ffab059fb46fe81d141
RUN set -x \
  && curl -fsSL https://get.docker.com/ | sh \
  && docker -v

ADD docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

VOLUME /var/lib/docker

