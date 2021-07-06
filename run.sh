#!/bin/bash
set -e

echo RUN DEBOT
debot_address=$(cat address.log)
echo $debot_address
~/git/tonos-cli/target/release/tonos-cli debot fetch $debot_address


#./tonos-cli debot fetch 0:bf879069dcc1a3fd3979463b60d324a951085e8c79d2e6e064f78a36d085665e
