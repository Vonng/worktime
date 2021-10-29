#==============================================================#
# File      :   Makefile
# Ctime     :   2021-10-29
# Mtime     :   2021-10-29
# Desc      :   Makefile shortcuts for worktime app
# Path      :   Makefile
# Copyright (C) 2019-2021 Ruohang Feng
#==============================================================#

# pigsty environment
METADB_URL?=postgres://dbuser_dba:DBUser.DBA@10.10.10.10/meta
GRAFANA_USERNAME?=admin
GRAFANA_PASSWORD?=pigsty
GRAFANA_ENDPOINT?=http://10.10.10.10:3000

#-----------------------------#
# entry
#-----------------------------#
default: all
all: sql ui

#-----------------------------#
# install
#-----------------------------#
ui:
	cd ui && ./grafana.py load

sql: ddl load


#-----------------------------#
# database
#-----------------------------#
ddl:
	psql $(METADB_URL) -f sql/000_base.sql

load:
	cat data/worktime.csv | psql $(METADB_URL) -c 'TRUNCATE worktime.worktime CASCADE; COPY worktime.worktime FROM STDIN CSV HEADER'

dump:
	psql $(METADB_URL) -c 'COPY (SELECT * FROM worktime.worktime ORDER BY id) TO STDOUT CSV HEADER' > data/worktime.csv

clean:
	psql $(METADB_URL) -c 'DROP SCHEMA worktime CASCADE;'


.PHONY: default all ui sql ddl load dump clean