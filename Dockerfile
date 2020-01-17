FROM lsiobase/ubuntu:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
ARG QBITTORRENT_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs, thelamer"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV HOME="/config" \
XDG_CONFIG_HOME="/config" \
XDG_DATA_HOME="/config"

# add repo and install qbitorrent
RUN \
 echo "***** install base package ****" && \
 apt-get update && \
 apt-get install -y \
	gnupg \
	python

RUN \
 echo "***** add qbitorrent repositories ****" && \
 apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 65121492 && \
 echo "deb http://ppa.launchpad.net/poplite/qbittorrent-enhanced/ubuntu bionic main" >> /etc/apt/sources.list.d/qbitorrent.list && \
 echo "deb-src http://ppa.launchpad.net/poplite/qbittorrent-enhanced/ubuntu bionic main" >> /etc/apt/sources.list.d/qbitorrent.list

RUN \
 echo "**** start install qbittorrent-ee ****" && \
 apt-get update && \
 apt-get install -y \
	p7zip-full \
	qbittorrent-enhanced-nox \
	unrar \
	geoip-bin \
	unzip

RUN \
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 6881 6881/udp 8080
VOLUME /config /downloads
