FROM mcr.microsoft.com/mssql/server:2025-latest

RUN mkdir /tmp/initscripts/

COPY initdbserver.sh    /tmp/initscripts/
COPY healthcheck.sh     /tmp/initscripts/

COPY *.sql              /tmp/initscripts/
COPY maintenance/*.sql  /tmp/initscripts/
