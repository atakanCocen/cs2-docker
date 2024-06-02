#!/bin/bash

for dir in plugins/*/; do
	plugin=$(basename $dir)
    echo "Building plugin: $plugin"
    
    # Create a sub-shell to avoid changing the current directory in the overall script
    (
        # Change to the current plugin directory
        cd $dir

        # Build the plugin which will output to $dir/bin/Release/net8.0/
        dotnet publish -c Release
    )

    # Copy the plugin to the output folder
    mkdir -p target/$dir
    cp $dir/bin/Release/net8.0/*.* target/$dir/
done
