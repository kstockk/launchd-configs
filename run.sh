#! /bin/bash

#
# My Custom Launchd Config File
#

#
# Ensure /bin/bash has Full Disk Access
# https://apple.stackexchange.com/questions/376474/enabling-bin-bash-on-catalina-invisible-to-system-preferences-security-p
#

#
# Default local user account LaunchAgent directory
# Custom launchd plists should contain name of current user account
#
LAUNCHD_DIR=/Users/$(whoami)/Library/LaunchAgents/
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
MY_LAUNCHD=$SCRIPTPATH/LaunchAgents/

# Create symbolic links (interactive)
ln -si $MY_LAUNCHD* $LAUNCHD_DIR

# Load all of my custom launchd processes
# Assumes that all requirements for the custom launchd processes are met
# as this script doesn't test anything... Only loads them in...
for file in $LAUNCHD_DIR*; do
    if [[ "$file" == *com.$(whoami).*.plist ]]; then
        launchctl unload $file
        launchctl load $file
    fi
done

# Remove broken symbolic links from ${LAUNCHD_DIR}
find $LAUNCHD_DIR -xtype l -delete

# Output
echo "My Active Launchd Processes"
launchctl list | grep $(whoami)