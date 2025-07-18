FROM mcr.microsoft.com/mssql/server:2022-latest

RUN mkdir /tmp/initscripts
COPY database/*.sql /tmp/initscripts/
COPY database/*.sh  /tmp/initscripts/

ENTRYPOINT ["/tmp/initscripts/entrypoint.sh"]
