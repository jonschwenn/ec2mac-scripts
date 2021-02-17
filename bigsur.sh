#!/bin/bash

# Unattended in-place Big Sur MacOS 11.x upgrade for EC2 Mac instances 

# NOTES:
# Soft reboot takes about 10 min without any software updates
# Start/Stop takes ~45 min due to Dedicated Host scrub process
# Plan to use io1/io2 w/3000 IOPS to make the upgrade speedy (<80min)
# Set EBS Volume to be 70+ GB


# RESIZE VOLUME
PDISK=$(diskutil list physical external | head -n1 | cut -d' ' -f1)
APFSCONT=$(diskutil list physical external | grep Apple_APFS | tr -s ' ' | cut -d' ' -f8)
yes | sudo diskutil repairDisk $PDISK
sudo diskutil apfs resizeContainer $APFSCONT 0

# GET INSTALLER
softwareupdate --fetch-full-installer 11.2.1

# START INSTALLER
sudo /Applications/Install\ macOS\ Big\ Sur.app/Contents/Resources/startosinstall --agreetolicense --forcequitapps --nointeraction
