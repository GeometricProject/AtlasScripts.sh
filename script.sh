#!/bin/bash

# Put your device IPs here
DEVICES=("device1" "device2")

# you need to go to this URL and download it.
APK_MIRROR_URL="https://www.apkmirror.com/apk/niantic-inc/pokemon-go/pokemon-go-0-275-1-release/pokemon-go-0-275-1-android-apk-download/ (32 bit) or https://www.apkmirror.com/apk/niantic-inc/pokemon-go/pokemon-go-0-275-1-release/pokemon-go-0-275-1-2-android-apk-download/ (64 bit)"

PGO="pgo.apk"
# then mv the file to pokemongo.apk

if [ -f "pgo.apk" ]; then
    echo "PGO found, continuing"
else 
    echo "Go to $APK_MIRROR_URL and download PGO.  Then save it in this directory as pgo.apk"
    exit;
fi

PKMD="PokemodAtlas-Public-v22071801.apk"
if [ -f "$PKMD" ]; then
    echo "$PKMD already exists, using local file"
else 
    echo "Downloading atlas release."
    ATLAS_URL="https://cdn.discordapp.com/attachments/967028686312337478/998630779892539402/PokemodAtlas-Public-v22071801.apk"

	curl -O $ATLAS_URL
fi

ADB="adb"

WHICH_ADB=$(which $ADB)

if [ x"${WHICH_ADB}" == "x" ]; then
    echo "adb not installed, exiting"
    exit;
else
    echo "Using adb at $WHICH_ADB"
fi

$ADB kill-server

if [ ! -f "atlas_config.json" ]; then
    echo "atlas_config.json not found, exiting"
    echo "Get an example at https://github.com/Astu04/AtlasScripts/blob/main/atlas_config.example.json"
    exit;
fi

if [ ! -f "emagisk.config" ]; then
    echo "emagisk.config not found, exiting"
    echo "Get an example at https://github.com/Astu04/AtlasScripts/blob/main/emagisk.example.json"
    exit;
fi

function setup_device {
    IP=$1
    $ADB connect $IP
    $ADB -s $IP install -r "$PKMD"
    $ADB -s $IP install -r "$PGO"
    $ADB -s $IP push atlas_config.json /data/local/tmp/atlas_config.json
    $ADB -s $IP push emagisk.config /data/local/tmp/emagisk.config
    $ADB -s $IP shell "su -c 'mount -o remount,rw /system'"
    if [ -f "authorized_keys" ]; then
       $ADB -s $IP push authorized_keys /sdcard/authorized_keys
    fi
    if [ -f "onBoot.sh" ]; then 
       $ADB -s $IP push onBoot.sh /sdcard/onBoot.sh
       $ADB -s $IP shell "chmod +x /sdcard/onBoot.sh"
       $ADB -s $IP shell "su -c 'mount -o remount,rw /system'"
       $ADB -s $IP shell "echo 'sh /sdcard/onBoot.sh' > /sdcard/44onBoot"
       $ADB -s $IP shell "chmod +x /sdcard/44onBoot"
       $ADB -s $IP shell "su -c mv /sdcard/44onBoot /etc/init.d/44onBoot"
    fi
    $ADB -s $IP shell "/system/bin/curl -s -k -L https://raw.githubusercontent.com/Astu04/AtlasScripts/main/first_install.sh | su -c sh"
    sleep 60
}


adb tcpip 5555

for value in "${DEVICES[@]}"
do
  setup_device $value
done
