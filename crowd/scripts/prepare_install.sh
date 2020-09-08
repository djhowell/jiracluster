#!/bin/bash
# This file /etc/atl required by ansible script, contains the vars
# Azure file storage to be created beforehand
echo "AZURE_STORAGE_ACCOUNT=$1" >> /etc/atl
echo "AZURE_STORAGE_KEY=$2" >> /etc/atl
echo "ATL_CROWD_SHARED_HOME_NAME=$3" >> /etc/atl
echo "ATL_TOMCAT_DEFAULTCONNECTORPORT=8095" >> /etc/atl
# Defaults in Setup Wizard
case $4 in
    sqlserver)
        echo 'ATL_DB_ENGINE=azure_sql' >> /etc/atl
        echo 'ATL_DB_PORT=1433' >> /etc/atl
        JDBC_URL=`echo $9 | base64 -d`
        echo "JDBC_URL=$JDBC_URL" >> /etc/atl
        echo 'ATL_DB_ROOT_DB_NAME=master' >> /etc/atl
    ;;
    postgres)
        echo 'JDBC_DRIVER=org.postgresql.Driver' >> /etc/atl
        echo 'JDBC_DIALECT=org.hibernate.dialect.PostgreSQLDialect' >> /etc/atl
        echo 'ATL_DB_ENGINE=rds_postgres' >> /etc/atl
        echo 'ATL_DB_PORT=5432' >> /etc/atl
        JDBC_URL=`echo $9 | base64 -d`
        echo "JDBC_URL=$JDBC_URL" >> /etc/atl
        echo 'ATL_DB_ROOT_DB_NAME=postgres' >> /etc/atl
    ;;
esac

echo "JDBC_USER=$5" >> /etc/atl
echo "JDBC_PASSWORD=$6" >> /etc/atl
# DB to be created beforehand
echo "ATL_JDBC_DB_NAME=${10}" >> /etc/atl
echo "ATL_JDBC_USER=crowddbuser" >> /etc/atl
echo "ATL_JDBC_PASSWORD=$6" >> /etc/atl
echo "ATL_DB_HOST=$7" >> /etc/atl
echo "ATL_DB_ROOT_USER=$5" >> /etc/atl #admin user
echo "ATL_DB_ROOT_PASSWORD=$6" >> /etc/atl #admin password
echo "APPINSIGHTS_INSTRUMENTATION_KEY=$8" >> /etc/atl
echo "ATL_TOMCAT_SECURE=false" >> /etc/atl
#Introduce a delay to allow database to be ready
sleep 10m
# Install ansible dependancies
mkdir -p /usr/lib/systemd/system
mkdir -p /opt/atlassian
apt update > /dev/null 2>&1
apt-get install -y python3.7 git > /dev/null 2>&1
# Clone playbook repo (azure-crowd branch instead of master)
git clone -b azure_deployments https://bitbucket.org/atlassian/dc-deployments-automation.git /opt/atlassian/dc-deployments-automation/
# Install ansible & execute playbook
cd /opt/atlassian/dc-deployments-automation/ && ./bin/install-ansible && ./bin/ansible-with-atl-env inv/azure_node_local azure_crowd_dc_node.yml /var/log/ansible-bootstrap.log