
#!/bin/bash
set -e

DEBOT_NAME=helloDebot

CLI_PATH=~/git/tonos-cli/target/release
NET_GIVER_PATH=~/givers/net_giver

function giver_net {
$CLI_PATH/tonos-cli call 0:2bb4a0e8391e7ea8877f4825064924bd41ce110fce97e939d3323999e1efbb13 sendTransaction "{\"dest\":\"$1\",\"value\":1000000000,\"bounce\":\"false\"}" --abi $NET_GIVER_PATH/giver.abi.json --sign $NET_GIVER_PATH/keys.json
}

function get_address {
echo $(cat log.log | grep "Raw address:" | cut -d ' ' -f 3)
}
function genaddr {
$CLI_PATH/tonos-cli genaddr $1.tvc $1.abi.json --genkey $1.keys.json > log.log
}

NETWORK=https://net.ton.dev


#DEBOT_ADDRESS=$(cat address.log)
#$CLI_PATH/tonos-cli --url $NETWORK call $DEBOT_ADDRESS deployDevice "{\"initNo\":\"0xDE\"}" --sign $DEBOT_NAME.keys.json --abi $DEBOT_NAME.abi.json
#exit 1

echo GENADDR DEBOT
genaddr $DEBOT_NAME
DEBOT_ADDRESS=$(get_address)

echo ASK GIVER
giver_net $DEBOT_ADDRESS
DEBOT_ABI=$(cat $DEBOT_NAME.abi.json | xxd -ps -c 20000)
echo DEPLOY DEBOT $DEBOT_ADDRESS
$CLI_PATH/tonos-cli --url $NETWORK deploy $DEBOT_NAME.tvc "{}" --sign $DEBOT_NAME.keys.json --abi $DEBOT_NAME.abi.json
$CLI_PATH/tonos-cli --url $NETWORK call $DEBOT_ADDRESS setABI "{\"dabi\":\"$DEBOT_ABI\"}" --sign $DEBOT_NAME.keys.json --abi $DEBOT_NAME.abi.json
#device=$(base64 -w 0 device.tvc)
device=$(cat device_code.txt)
$CLI_PATH/tonos-cli --url $NETWORK call $DEBOT_ADDRESS setDeviceCode "{\"code\":\"$device\"}" --sign $DEBOT_NAME.keys.json --abi $DEBOT_NAME.abi.json
#$CLI_PATH/tonos-cli --url $NETWORK call $DEBOT_ADDRESS deployDevice "{\"initNo\":\"0xDE\"}" --sign $DEBOT_NAME.keys.json --abi $DEBOT_NAME.abi.json

echo DONE
echo $DEBOT_ADDRESS > address.log
echo debot $DEBOT_ADDRESS
