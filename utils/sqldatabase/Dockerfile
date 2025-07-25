FROM mcr.microsoft.com/mssql/server:2022-latest

RUN mkdir /tmp/initscripts

COPY entrypoint.sh                        /tmp/initscripts/entrypoint.sh
COPY initdb.sh                            /tmp/initscripts/initdb.sh
COPY *.sql                                /tmp/initscripts/
COPY download/mssql-create_database.sql   /tmp/initscripts/mssql-create_database.sql

ENTRYPOINT ["/tmp/initscripts/entrypoint.sh"]
