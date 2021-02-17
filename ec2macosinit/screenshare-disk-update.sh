#!/bin/bash
# You don't need sudo within user-data, but left in for
# reference when running commands manually

# SCREEN SHARE
# You'll need to SSH in and 'sudo passwd ec2-user' to set
# a password for Screen Sharing
echo "ENABLING SCREEN SHARING"
sudo launchctl enable system/com.apple.screensharing
sleep 5
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist
echo "------------------------"
# VOLUME EXPAND
echo "EXPANDING APFS VOLUME"
PDISK=$(diskutil list physical external | head -n1 | cut -d' ' -f1)
APFSCONT=$(diskutil list physical external | grep Apple_APFS | tr -s ' ' | cut -d' ' -f8)
yes | sudo diskutil repairDisk $PDISK
sudo diskutil apfs resizeContainer $APFSCONT 0
echo "------------------------"
# SOFTWARE UPDATE
echo "RUNNING SOFTWARE UPDATES"
su - ec2-user -c "brew update"
su - ec2-user -c "brew upgrade"
sudo softwareupdate -i -r --restart
