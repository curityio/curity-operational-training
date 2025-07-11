#
# A job container to initialize an Azure SQL database for the Curity Identity Server
#

FROM mcr.microsoft.com/mssql-tools

ARG DBSERVER_ARG
ENV DBSERVER=$DBSERVER_ARG

RUN apt-get update && apt-get install -y curl jq

RUN mkdir /tmp/initscripts
COPY idsvr-dbinit/*.sql /tmp/initscripts/
COPY idsvr-dbinit/*.sh  /tmp/initscripts/

ENTRYPOINT ["/tmp/initscripts/entrypoint.sh"]
