for dir in plugins/*/; do
	plugin=$(basename $dir)
    echo "Pulling latest changes for plugin: $plugin"
    
    # Create a sub-shell to avoid changing the current directory in the overall script
    (
        # Change to the current plugin directory
        cd $dir

        # Build the plugin which will output to $dir/bin/Release/net8.0/
        git pull
    )
done
