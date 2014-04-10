###############################################
# Ubuntu with added Teamspeak 3 Server. 
# Uses SQLite Database on default.
###############################################

# Using latest Ubuntu image as base
FROM ubuntu

MAINTAINER Alex

## Set some variables for override.
# Download Link of TS3 Server
ENV TEAMSPEAK_URL http://dl.4players.de/ts/releases/3.0.10.3/teamspeak3-server_linux-amd64-3.0.10.3.tar.gz


# Inject a Volume for any TS3-Data that needs to be persisted or to be accessible from the host. (e.g. for Backups)
VOLUME ["/teamspeak3"]

# Update app-get index and install curl to download TS3 file.
RUN apt-get update && apt-get install -y curl

# Download TS3 file and extract it into /opt.
RUN cd /opt && curl -sL ${TEAMSPEAK_URL} | tar xz

# create symlink for the sqlite db
RUN cd /opt/teamspeak3-server_linux-amd64 && mklink ts3server.sqlitedb "/teamspeak3/ts3server.sqlitedb"

# TODO symlink for files-dir

# Use CMD to set some defaults, for example mapping some files/directorys to the injected volume.
CMD ["logpath=/teamspeak3/logs/", "licensepath=/teamspeak3/", "inifile=/teamspeak3/ts3server.ini", "query_ip_whitelist=/teamspeak3/query_ip_whitelist.txt", "query_ip_backlist=/teamspeak3/query_ip_blacklist.txt"]

# Specify an entrypoint because this container should act like a isolated "application" and only serve TS3.
ENTRYPOINT ["/opt/teamspeak3-server_linux-amd64/ts3server_minimal_runscript.sh"]

# Expose the Standard TS3 port.
EXPOSE 9987/udp
