FROM mariadb:10.6

COPY init.sql /docker-entrypoint-initdb.d/

ENV MARIADB_ROOT_PASSWORD=root
ENV MARIADB_DATABASE=greenshop
