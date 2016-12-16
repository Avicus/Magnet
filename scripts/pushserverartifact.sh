#!/bin/bash
if [ -z "$1" ]; then
	echo "Need version"
	exit 1
fi
ver=$1-SNAPSHOT
base=minecraft-server-$ver
cd ~/.m2/repository/org/spigotmc/minecraft-server/$ver/
mvn deploy:deploy-file -DpomFile=$base.pom -Dfile=$base.jar -DrepositoryId=avicus-repo -Durl=https://repo.avicus.net/content/repositories/snapshots-private/
