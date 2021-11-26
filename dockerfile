# from image passed in dockerfile (either arm or x64)
ARG IMAGE

# get the latest SQL container
FROM $IMAGE

# add an argument that will later help designate the stocked sql server
ARG PRIMARYSQL

# switch to root to a bunch of stuff that requires elevated privs
USER root

# copy scripts and make bash files executable
# also create a shared directory and make it writable by mssql
RUN mkdir /dbatools-setup /shared
WORKDIR /dbatools-setup
ADD sql scripts /dbatools-setup/
RUN chmod +x /dbatools-setup/*.sh
RUN chown mssql /shared /dbatools-setup

# write a file that designates the primary server
# this is used in a later step to load up the server
RUN if [ $PRIMARYSQL ]; then touch /dbatools-setup/primary; fi

# run initial setup scripts then start the service for good
USER mssql
RUN /bin/bash /dbatools-setup/initial-start.sh
ENTRYPOINT /opt/mssql/bin/sqlservr