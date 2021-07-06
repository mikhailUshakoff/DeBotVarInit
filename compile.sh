#!/bin/bash
set -e
filename=helloDebot
filenamesol=$filename.sol
filenamecode=$filename.code
filenametvc=$filename.tvc
function get_tvc {
echo $(cat comp.log | grep "Saved contract to file " | cut -d ' ' -f 5)    
}

echo COMPILE DEBOT $filenamesol
#~/depool_debot/tools/TON-Solidity-Compiler/build/solc/solc $filenamesol
#~/git/sol2tvm/build/solc/solc --version
~/git/sol2tvm/build/solc/solc $filenamesol --tvm-optimize --tvm-unsaved-structs
#~/git/TON-Solidity-Compiler/build/solc/solc --version
#~/git/TON-Solidity-Compiler/build/solc/solc $filenamesol
sleep 1
echo LINK DEBOT $filenamesol
#change TVM_LINKER_LIB_PATH path to linker path.. nano  ~/.bashrc
~/git/TVM-linker/tvm_linker/target/release/tvm_linker compile $filenamecode > comp.log
echo DONE
new_name=$(get_tvc)
echo $new_name
rm -f $filenametvc
mv $new_name $filenametvc


