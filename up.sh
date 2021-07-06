#!/bin/bash
set -e

filename=helloDebot
filenamesol=$filename.sol
filenameabi=$filename.abi.json
filenametvc=$filename.tvc
filenamekeys=$filename.keys.json

CLI_PATH=~/git/tonos-cli/target/release

debot=$(cat address.log)

$CLI_PATH/tonos-cli call $debot deployDevice "{\"initNo\":\"0x2\"}" --sign $filename.keys.json --abi $filename.abi.json

echo DONE
