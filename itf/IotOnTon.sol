pragma ton-solidity >=0.40.0;

interface IIotOnTon {

    function setAESKey(uint32 answerId, string mac) external returns (bool res);
    function getDeviceId(uint32 answerId, string mac) external returns (uint256 id);

}

library IotOnTon {

	uint256 constant ID = 0x3d7143f1714c731ca5854b2bbfdd39adbf5639a5441290b588498c10c77448e9;
	int8 constant DEBOT_WC = -31;

	function setAESKey(uint32 answerId, string mac) public pure {
		address addr = address.makeAddrStd(DEBOT_WC, ID);
		IIotOnTon(addr).setAESKey(answerId, mac);
	}

	function getDeviceId(uint32 answerId, string mac) public pure {
		address addr = address.makeAddrStd(DEBOT_WC, ID);
		IIotOnTon(addr).getDeviceId(answerId, mac);
	}
} 

contract IotOnTonABI is IIotOnTon {

    function setAESKey(uint32 answerId, string mac) external override returns (bool res)  {}
    function getDeviceId(uint32 answerId, string mac) external override returns (uint256 id) {}

}

