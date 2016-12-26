<<<<<<< HEAD
###############################################
# Ubuntu with added Teamspeak 3 Server.
# Uses SQLite Database on default.
###############################################

# Using latest Ubuntu image as base
FROM ubuntu:16.04
=======
FROM frolvlad/alpine-glibc:alpine-3.4

MAINTAINER BastiOfBerlin
>>>>>>> f41154ea059acbc6433c0395b1c286b4acedb5aa

ENV TEAMSPEAK_URL=http://dl.4players.de/ts/releases/3.0.13.6/teamspeak3-server_linux_amd64-3.0.13.6.tar.bz2 \
    TS3_UID=1000

<<<<<<< HEAD
RUN apt-get update \
        && apt-get install -y wget bzip2 --no-install-recommends \
        && rm -r /var/lib/apt/lists/*

## Set some variables for override.
# Download Link of TS3 Server
ENV TEAMSPEAK_VERSION 3.0.13.6
ENV TEAMSPEAK_SHA256 19ccd8db5427758d972a864b70d4a1263ebb9628fcc42c3de75ba87de105d179
=======
RUN adduser -S -D -u ${TS3_UID} ts3 \
  && mkdir -p /home/ts3 \
  && wget -q -O /home/ts3/teamspeak3-server_linux_amd64.tar.bz2 ${TEAMSPEAK_URL} \
  && tar --directory /home/ts3 -xjf /home/ts3/teamspeak3-server_linux_amd64.tar.bz2 \
  && rm /home/ts3/teamspeak3-server_linux_amd64.tar.bz2 \
  && mkdir -p /home/ts3/data/logs \
  && mkdir -p /home/ts3/data/files \
 # && ln -s /home/ts3/data/files /home/ts3/teamspeak3-server_linux_amd64 \
  && ln -s /home/ts3/data/ts3server.sqlitedb /home/ts3/teamspeak3-server_linux_amd64/ts3server.sqlitedb \
  && chown -R ts3 /home/ts3 
# Symlink because i dont know how to move sqlite-db (like dbpath=/data/ts/mysqlite.db)
>>>>>>> f41154ea059acbc6433c0395b1c286b4acedb5aa

USER ts3
ENTRYPOINT ["/home/ts3/teamspeak3-server_linux_amd64/ts3server_minimal_runscript.sh"]
CMD ["inifile=/home/ts3/data/ts3server.ini", "logpath=/home/ts3/data/logs","licensepath=/home/ts3/data/","query_ip_whitelist=/home/ts3/data/query_ip_whitelist.txt","query_ip_backlist=/home/ts3/data/query_ip_blacklist.txt"]

<<<<<<< HEAD
# Download TS3 file and extract it into /opt.
RUN wget -O teamspeak3-server_linux-amd64.tar.bz2 http://dl.4players.de/ts/releases/${TEAMSPEAK_VERSION}/teamspeak3-server_linux_amd64-${TEAMSPEAK_VERSION}.tar.bz2 \
        && echo "${TEAMSPEAK_SHA256} *teamspeak3-server_linux-amd64.tar.bz2" | sha256sum -c - \
        && tar -C /opt -xjf teamspeak3-server_linux-amd64.tar.bz2 \
        && rm teamspeak3-server_linux-amd64.tar.bz2

ADD /scripts/ /opt/scripts/
RUN chmod -R 774 /opt/scripts/

ENTRYPOINT ["/opt/scripts/docker-ts3.sh"]
#CMD ["-w", "/teamspeak3/query_ip_whitelist.txt", "-b", "/teamspeak3/query_ip_blacklist.txt", "-o", "/teamspeak3/logs/", "-l", "/teamspeak3/"]

# Expose the Standard TS3 port.
EXPOSE 9987/udp
# for files
EXPOSE 30033
# for ServerQuery
EXPOSE 10011
=======
VOLUME ["/home/ts3/data"]

# Expose the Standard TS3 port, for files, for serverquery
EXPOSE 9987/udp 30033 10011
>>>>>>> f41154ea059acbc6433c0395b1c286b4acedb5aa
