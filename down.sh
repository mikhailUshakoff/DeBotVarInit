#!/bin/bash
set -e

filename=helloDebot
filenamesol=$filename.sol
filenameabi=$filename.abi.json
filenametvc=$filename.tvc
filenamekeys=$filename.keys.json

CLI_PATH=~/git/tonos-cli/target/release

address=0:9e6a7c51ba2091cfb3a716cae5c21f4a2841e0472162e7b51138814241204547

$CLI_PATH/tonos-cli call $address remove "{\"dest\":\"0:2bb4a0e8391e7ea8877f4825064924bd41ce110fce97e939d3323999e1efbb13\"}" --sign $filename.keys.json --abi device.abi.json

echo DONE
