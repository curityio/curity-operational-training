FROM mcr.microsoft.com/mssql/server:2022-latest

RUN mkdir /tmp/initscripts/

COPY *.sh                               /tmp/initscripts/
COPY *.sql                              /tmp/initscripts/
COPY maintenance/*.sql                  /tmp/initscripts/
COPY download/mssql-create_database.sql /tmp/initscripts/

ENTRYPOINT ["/tmp/initscripts/entrypoint.sh"]
