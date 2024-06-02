#!/bin/bash

INSTALL_SCRIPT="$STEAMAPPDIR/install-plugins.sh"

rm -f $INSTALL_SCRIPT
cp /etc/install-plugins.sh $INSTALL_SCRIPT

bash $INSTALL_SCRIPT
