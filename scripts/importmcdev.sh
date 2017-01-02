#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
	DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
	SOURCE="$(readlink "$SOURCE")"
	[[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
. $(dirname $SOURCE)/init.sh

workdir=$basedir/base/Paper/work
minecraftversion=$(cat $basedir/base/Paper/BuildData/info.json | grep minecraftVersion | cut -d '"' -f 4)
decompiledir=$workdir/$minecraftversion

nms="net/minecraft/server"
export MODLOG=""
cd $basedir

export importedmcdev=""
function import {
	export importedmcdev="$importedmcdev $1"
	file="${1}.java"
	target="$basedir/Magnet-Server/src/main/java/$nms/$file"
	base="$decompiledir/$nms/$file"

	if [[ ! -f "$target" ]]; then
		export MODLOG="$MODLOG  Imported $file from mc-dev\n";
		echo "Copying $base to $target"
		cp "$base" "$target"
	else
		echo "UN-NEEDED IMPORT STATEMENT: $file"
	fi
}

(
	cd base/Paper/PaperSpigot-Server/
	lastlog=$(git log -1 --oneline)
	if [[ "$lastlog" = *"Magnet-Server mc-dev Imports"* ]]; then
		git reset --hard HEAD^
	fi
)
import PacketPlayOutPlayerInfo
import PacketPlayOutScoreBoardTeam
(
	cd Magnet-Server/
	rm -rf nms-patches
	git add src -A
	echo -e "Magnet-Server mc-dev Imports\n\n$MODLOG" | git commit src -F -
)
