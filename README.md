# Atlas Scripts for Macs/Linux/etc

This is derived version of https://github.com/Astu04/AtlasScripts which is meant to run on macs/linux hosts.

`script.sh` replaces `one_click.bat` and follow all other directions from there.

If you don't want to worry about all of the automation, you can just do these steps:

```
$ADB connect $IP
$ADB -s $IP install -r "$PKMD"
$ADB -s $IP install -r "$PGO"
$ADB -s $IP push atlas_config.json /data/local/tmp/atlas_config.json
$ADB -s $IP push emagisk.config /data/local/tmp/emagisk.config
```

then run:

```
adb -s $IP shell 'am force-stop com.nianticlabs.pokemongo && am force-stop com.pokemod.atlas && am startservice com.pokemod.atlas/com.pokemod.atlas.services.MappingService'
```