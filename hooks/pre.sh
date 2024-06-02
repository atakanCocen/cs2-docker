#!/bin/bash

METAMOD_URL="https://mms.alliedmods.net/mmsdrop/1.11/mmsource-1.11.0-git1155-linux.tar.gz"
CS_SHARP_URL="https://github.com/roflmuffin/CounterStrikeSharp/releases/download/v239/counterstrikesharp-with-runtime-build-239-linux-a695eec.zip"

CSGO_DIR="game/csgo"
ADDONS_DIR="$CSGO_DIR/addons"
METAMOD_DIR="$ADDONS_DIR/metamod"
CS_SHARP_DIR="$ADDONS_DIR/counterstrikesharp"


# Create addons directory if it doesn't exist
if [[ ! -d "$ADDONS_DIR" ]] ; then
	echo "Creating addons directory"
	mkdir -p $ADDONS_DIR
else
	echo "Addons directory already exists"
fi


# Download Metamod if it doesn't exist
if [[ ! -d $METAMOD_DIR ]] ; then
	echo "Downloading Metamod"

	curl $METAMOD_URL | tar -xz -C $CSGO_DIR
else
	echo "Metamod already installed"
fi


# Update gameinfo.gi to include Metamod
if [[ -f "$CSGO_DIR/gameinfo.gi" ]] ; then
	echo "Found gameinfo.gi"

	if [[ -z $(grep "metamod" $CSGO_DIR/gameinfo.gi) ]] ; then
		echo "Adding metamod to gameinfo.gi"
		sed -i '' -e "/Game_LowViolence/a\\
			Game	csgo\/addons\/metamod" $CSGO_DIR/gameinfo.gi
	else
		echo "gameinfo.gi already updated"
	fi
else
	echo "WARNING: gameinfo.gi not found"
fi


# Download CounterStrikeSharp if it doesn't exist
if [[ ! -d $CS_SHARP_DIR ]] ; then
	echo "Downloading CounterStrikeSharp"

	curl -Lo counterstrikesharp.zip $CS_SHARP_URL
	unzip -qo counterstrikesharp.zip -d $CSGO_DIR
	rm -f counterstrikesharp.zip
else
	echo "CounterStrikeSharp already installed"
fi
