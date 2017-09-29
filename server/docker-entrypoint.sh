#!/bin/bash

if [ $KEYCLOAK_USER ] && [ $KEYCLOAK_PASSWORD ]; then
    keycloak/bin/add-user-keycloak.sh --user $KEYCLOAK_USER --password $KEYCLOAK_PASSWORD
fi


if [ "$DB_VENDOR" == "POSTGRES" ]; then
  databaseToInstall="postgres"
elif [ "$DB_VENDOR" == "MYSQL" ]; then
  databaseToInstall="mysql"
elif [ "$DB_VENDOR" == "H2" ]; then
  databaseToInstall=""
else
    if [ $POSTGRES_DATABASE ]; then
        databaseToInstall="postgres"
    elif [ $MYSQL_DATABASE ]; then
      databaseToInstall="mysql"
    fi
fi

if [ "$databaseToInstall" != "" ]; then
    echo "[KEYCLOAK DOCKER IMAGE] Using the external $databaseToInstall database"
    /bin/sh /opt/jboss/keycloak/databases/$databaseToInstall/changeDatabase.sh
else
    echo "[KEYCLOAK DOCKER IMAGE] Using the embedded H2 database"
fi

exec /opt/jboss/keycloak/bin/standalone.sh $@
exit $?
