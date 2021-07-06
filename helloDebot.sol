pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;
// import required DeBot interfaces and basic DeBot contract.
import "Debot.sol";
import "itf/Sdk.sol";
import "itf/Terminal.sol";
import "itf/Menu.sol";
import "itf/ConfirmInput.sol";
//import "itf/Msg.sol";
import "itf/AddressInput.sol";
import "itf/AmountInput.sol";
import "itf/Hex.sol";
import "itf/SecurityCardManagement.sol";
import "itf/QRCode.sol";
import "itf/UserInfo.sol";
import "itf/IotOnTon.sol";
import "itf/Aes.sol";
import "device.sol";
import "Upgradable.sol";

abstract contract AIotClient {
   constructor() public {}
   function addDevice(string name, address addr) public {}
   function delDevice(address addr) public {}
   function getDevices() public returns (mapping(address => string)) {}
}

abstract contract AIotDevice {
   uint256 static m_id;
   constructor() public {}
   function getData() public returns (bytes) {}
}
/*
abstract contract Device {
    uint256 static m_id;
}*/

contract HelloDebot is Debot, Upgradable {
    bytes m_icon;
    //TvmCell m_sendMsg;
    TvmCell m_iotClientCode;
    TvmCell m_iotDeviceCode;
    uint256 m_masterPubKey;
    address m_iotClient;
    address m_userMsig;
    address[] m_devices;
    string m_deviceMAC;
    string m_deviceName;
    address m_deviceAddr;
    uint256 m_deviceId;

    function setIcon(bytes icon) public {
        require(msg.pubkey() == tvm.pubkey(), 100);
        tvm.accept();
        m_icon = icon;
    }

    function setDeviceCode(TvmCell code) public {
        require(msg.pubkey() == tvm.pubkey(), 100);
        tvm.accept();
        m_iotDeviceCode = code;
    }

    

    /// @notice Entry point function for DeBot.
    function start() public override {
        // print string to user.
        Terminal.print(0, "Debot start!");
        // input string from user and define callback that receives entered string.
        AmountInput.get(tvm.functionId(addDeviceSetDeviceId),"input id", 0,1,100);
    }

    function addDeviceSetDeviceId(uint128 value) public {
        m_deviceId = value;
        m_deviceAddr =  address(tvm.hash(tvm.buildStateInit({
            code: m_iotDeviceCode,
            varInit: {m_id: m_deviceId},
            contr: Device
        })));
        isDeviceMoneySend(true);
    }

    function isDeviceMoneySend(bool value) public {
        if (value){
            Sdk.getAccountType(tvm.functionId(addDeviceCheckContract), m_deviceAddr);
        } else
            Terminal.print(tvm.functionId(Debot.start),"Terminated!");
    }

    function addDeviceCheckContract(int8 acc_type) public {
        if (acc_type==-1) {
            Terminal.print(0, "Send 0.1 ton or more to the address:");
            Terminal.print(0, format("{}",m_deviceAddr));
            ConfirmInput.get(tvm.functionId(isDeviceMoneySend),"Did you send the money?");
        }else if (acc_type==0) {
            Sdk.getBalance(tvm.functionId(checkIotDeviceBalance), m_deviceAddr);
            //Terminal.print(tvm.functionId(DeployFlexClientStep2Proxy), "Deploying..");
        }else if (acc_type==1){
            //Terminal.input(tvm.functionId(addDeviceName),"Input device name",false);
            Terminal.print(0,format("contract exist {}",m_deviceAddr));
            Terminal.print(0,"finish");
        } else if (acc_type==2){
            Terminal.print(tvm.functionId(Debot.start), format("Terminated! Account {} is frozen.",m_deviceAddr));
        }
    }

    function checkIotDeviceBalance(uint128 nanotokens) public {
        if (nanotokens<0.1 ton) {
            Terminal.print(0, format("Address {} balance is {:t} tons",m_deviceAddr,nanotokens));
            addDeviceCheckContract(-1);
        }else {
            Terminal.print(tvm.functionId(DeployIotDevice), "Deploying..");
        }
    }

    function DeployIotDevice() public {
            TvmCell image = tvm.buildStateInit({
                code: m_iotDeviceCode,
                varInit: {m_id: m_deviceId},
                contr: Device
            });
            address addr =  address(tvm.hash(image));
            optional(uint256) none;
            TvmCell deployMsg = tvm.buildExtMsg({
                abiVer: 2,
                dest: addr,
                callbackId: tvm.functionId(onSuccessDeviceDeployed),
                onErrorId: tvm.functionId(onDeployDeviceFailed),
                time: 0,
                expire: 0,
                sign: true,
                pubkey: none,
                stateInit: image,
                call: {AIotDevice}
            });
            tvm.sendrawmsg(deployMsg, 1);
    }

    function onSuccessDeviceDeployed() public {
        Terminal.print(0,"onSuccessDeviceDeployed");
        Terminal.print(0,"finish");
    }

    function onDeployDeviceFailed(uint32 sdkError, uint32 exitCode) public {
        Terminal.print(0, format("Deploy failed. Sdk error = {}, Error code = {}", sdkError, exitCode));
        Terminal.print(tvm.functionId(DeployIotDevice), "Retring");
    }

    /// @notice Returns Metadata about DeBot.
    function getDebotInfo() public functionID(0xDEB) override view returns(
        string name, string version, string publisher, string caption, string author,
        address support, string hello, string language, string dabi, bytes icon
    ) {
        name = "Test init state";
        version = "0.0.3";
        publisher = "";
        caption = "Test init state";
        author = "";
        support = address.makeAddrStd(0, 0);
        hello = "Hello, i am a DeBot.";
        language = "en";
        dabi = m_debotAbi.get();
        icon = m_icon;
    }

    function getRequiredInterfaces() public view override returns (uint256[] interfaces) {
        return [ Terminal.ID ];
    }

    function setUserInput(string value) public {
        // TODO: continue DeBot logic here...
        Terminal.print(0, format("You have entered \"{}\"", value));
    }

    //on chain call
    function deployDevice(uint256 initNo) public returns(address){
        tvm.accept();
        address addr = new Device {
            value: 0.1 ton,
            flag: 1,
            code: m_iotDeviceCode,
            varInit: {m_id: initNo}
        }();

        return addr;
        //TestDebot9(addr).deployNext{value: address(this).balance - 1 ton}(initNo);*/
    }

    /*
    *  Implementation of Upgradable
    */
    function onCodeUpgrade() internal override {
        tvm.resetStorage();
    }

}
