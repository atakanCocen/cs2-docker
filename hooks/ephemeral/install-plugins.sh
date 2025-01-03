#!/bin/bash

CSGO_DIR="$STEAMAPPDIR/game/csgo"
ADDONS_DIR="$CSGO_DIR/addons"
METAMOD_DIR="$ADDONS_DIR/metamod"
MAPS_DIR="$CSGO_DIR/maps"
CFG_DIR="$CSGO_DIR/cfg"
CS_SHARP_DIR="$ADDONS_DIR/counterstrikesharp"
CS_SHARP_PLUGINS_DIR="$CS_SHARP_DIR/plugins"
APP_MANIFEST_FILE="$STEAMAPPDIR/steamapps/appmanifest_730.acf"

# Create a snapshot.
# want to check the app manifest file
# get the last updated time out of app manifest file
# if the last updated time is within the last ~30 seconds
# if yes, we want to create a snapshot
CURRENT_TIME=$(date +%s)
LAST_UPDATED_TIME=$(sed -n 's/.*"LastUpdated"\s*"\([0-9]*\)".*/\1/p' $APP_MANIFEST_FILE)

if [ $(($CURRENT_TIME - $LAST_UPDATED_TIME)) -le 30 ]; then
	echo "Timestamp is within the last 30 seconds"
	SNAPSHOT_NAME=cs2-install
	TASK_ARN=$(curl -s "$ECS_CONTAINER_METADATA_URI_V4/task" | jq -r ".TaskARN")
	VOLUME_ID=$(aws ec2 describe-volumes --filters "Name=tag:AmazonECSCreated,Values=$TASK_ARN" --query 'Volumes[*].VolumeId' --output text)

	echo "CS2 was recently updated. Creating a snapshot for volume $VOLUME_ID"
	aws ec2 create-snapshot --volume-id $VOLUME_ID --description "Counter-Strike 2 Install Snapshot" --tag-specifications "ResourceType=snapshot,Tags=[{Key=Name,Value=$SNAPSHOT_NAME}]"
else
	echo "CS2 was not updated. Not creating a snapshot."
fi

# Create addons directory. Recreate if it already exists
if [[ -d "$ADDONS_DIR" ]] ; then
	echo "Addons directory already exists. Removing..."
	rm -rf $ADDONS_DIR
fi

echo "Creating addons directory"
mkdir -p $ADDONS_DIR

# Extract metamod if it doesn't exist
# https://docs.cssharp.dev/docs/guides/getting-started.html#installing-metamod
if [[ ! -d $METAMOD_DIR ]] ; then
	echo "Extracting metamod to $ADDONS_DIR"

	# -x tells tar to extract the zip
	# -z tells tar to use gzip
	# -f tells tar to use the following file
	# -C tells tar to where to extract the zip to
	tar xfz /tmp/metamod.tar.gz -C $CSGO_DIR
else
	echo "Metamod already installed"
fi


# Update gameinfo.gi to include Metamod
if [[ -f "$CSGO_DIR/gameinfo.gi" ]] ; then
	echo "Found gameinfo.gi"

	if [[ -z $(grep "metamod" $CSGO_DIR/gameinfo.gi) ]] ; then
		echo "Adding metamod to gameinfo.gi"

		# -i tells sed to edit the file in place, and the '' is required on OSX to avoid creating a backup file
		# -e tells sed to execute the following command. It looks for the line containing "Game_LowViolence" and appends the Metamod line after it
		# Note: sed does not support \n for newline, so the newline and tabs are literal
		sed -i -e "/Game_LowViolence/a\\
			Game	csgo\/addons\/metamod" $CSGO_DIR/gameinfo.gi
	else
		echo "gameinfo.gi already updated"
	fi
else
	echo "WARNING: gameinfo.gi not found"
fi


# Download CounterStrikeSharp if it doesn't exist
# https://docs.cssharp.dev/docs/guides/getting-started.html#installing-counterstrikesharp
if [[ ! -d $CS_SHARP_DIR ]] ; then
	echo "Extracting CounterStrikeSharp to $ADDONS_DIR"

	# -q tells unzip to stfu
	# -o tells unzip to overwrite files without prompting
	unzip -qo /tmp/counterstrikesharp.zip -d $CSGO_DIR
else
	echo "CounterStrikeSharp already installed"
fi

# Copy pre-baked CounterStrikeSharp plugins to plugins directory
# https://docs.cssharp.dev/docs/guides/hello-world-plugin.html#installing-your-plugin
for dir in /tmp/plugins/*/; do
	plugin=$(basename $dir)
	
	if [[ ! -d "$CS_SHARP_PLUGINS_DIR/$plugin" ]] ; then
		echo "Copying plugin to server: $plugin"
		cp -r $dir $CS_SHARP_PLUGINS_DIR
	else
		echo "$plugin plugin already exists. Not copying."
	fi
done

# Copy configs to cfg directory
cp /tmp/config/*.cfg $CFG_DIR
