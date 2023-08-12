# Atlas Scripts for Macs/Linux/etc

This is derived version of https://github.com/Astu04/AtlasScripts which is meant to run on macs/linux hosts.

`script.sh` replaces `one_click.bat` and follow all other directions from there.

## Simple Setup Instructions

If you don't want to worry about all of the automation, you can just do these steps:

1. Download PGO 275.1 from APK mirror:
- https://www.apkmirror.com/apk/niantic-inc/pokemon-go/pokemon-go-0-275-1-release/pokemon-go-0-275-1-android-apk-download/ (32 bit)
- https://www.apkmirror.com/apk/niantic-inc/pokemon-go/pokemon-go-0-275-1-release/pokemon-go-0-275-1-2-android-apk-download/ (64 bit)

Export the path to PGO like this:

```
export PGO="com.nianticlabs.pokemongo_0.275.1-2023062601_minAPI24\(arm64-v8a\)\(nodpi\)_apkmirror.com.apk"
```

2. Download Pokemod from Discord:
- https://cdn.discordapp.com/attachments/967028686312337478/998630779892539402/PokemodAtlas-Public-v22071801.apk

Export the path to it like this:

```
export PKMD="PokemodAtlas-Public-v22071801.apk"
```

3. For each device you're setting up, create an `atlas_config.json` file named `$IP.json` (replacing `$IP` with the device's IP or hostname).  You can use the sample in this repo.

4. Create a single `emagisk.config` with your RDM configuration in it.

5. Install PGO, Pokemod and setup configuration on the device:

```
$ADB connect $IP
$ADB -s $IP install -r "$PKMD"
$ADB -s $IP install -r "$PGO"
$ADB -s $IP push $IP.json /data/local/tmp/atlas_config.json
$ADB -s $IP push emgagisk.config /data/local/tmp/emagisk.config
```

6. Start Mapping:

```
$ADB -s $IP shell 'am force-stop com.nianticlabs.pokemongo && am force-stop com.pokemod.atlas && am startservice com.pokemod.atlas/com.pokemod.atlas.services.MappingService'
```

To start up pokemod.  You'll need to assign an instance and all that stuff in your RDM, but happy mapping.

Note that this is just a really simple setup.  You may need additional steps for monitoring, restarting, etc on the device.