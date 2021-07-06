#!/bin/bash
set -e

filename=helloDebot
filenamesol=$filename.sol
filenameabi=$filename.abi.json
filenametvc=$filename.tvc
filenamekeys=$filename.keys.json

CLI_PATH=~/git/tonos-cli/target/release

debot=$(cat address.log)
debot_name=$filename
debot_abi=$(cat $debot_name.abi.json | xxd -ps -c 20000)
new_state=$( base64 -w 0 $debot_name.tvc)

$CLI_PATH/tonos-cli call $debot upgrade "{\"state\":\"$new_state\"}" --sign $debot_name.keys.json --abi $debot_name.abi.json
$CLI_PATH/tonos-cli call $debot setABI "{\"dabi\":\"$debot_abi\"}" --sign $debot_name.keys.json --abi $debot_name.abi.json

#ICON=$(cat hellodebot.png | xxd -ps -c 20000)
#ICON_BYTES=$(base64 -w 0 hellodebot.png)
#ICON=$(echo -n "data:image/png;base64,$ICON_BYTES" | xxd -ps -c 20000)
#$CLI_PATH/tonos-cli call $debot setIcon "{\"icon\":\"$ICON\"}" --sign $filenamekeys --abi $filenameabi

echo DONE
