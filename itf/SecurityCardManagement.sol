pragma ton-solidity >=0.35.0;

interface ISecurityCardManagement {
    function getBlockHashes(uint32 answerId, uint192 sn) external returns (uint256 h2, uint256 h3); 
    function turnOnWallet(uint32 answerId, uint192 sn, uint128 p1, uint16 iv, uint32 cs) external returns (uint256 pubkey);
    function setRecoveryData(uint32 answerId, bytes recoveryData) external returns (bool result);
    function getRecoveryData(uint32 answerId) external returns (bytes recoveryData);
}

library SecurityCardManagement {

	uint256 constant ID = 0x5960c60629709699c0f80756ee9a4074dde26e8f68cddd03bf0507d8eb07915f;
	int8 constant DEBOT_WC = -31;

	function getBlockHashes(uint32 answerId, uint192 sn) public pure {
		address addr = address.makeAddrStd(DEBOT_WC, ID);
		ISecurityCardManagement(addr).getBlockHashes(answerId, sn);
	}
	function turnOnWallet(uint32 answerId, uint192 sn, uint128 p1, uint16 iv, uint32 cs) public pure {
		address addr = address.makeAddrStd(DEBOT_WC, ID);
		ISecurityCardManagement(addr).turnOnWallet(answerId, sn, p1, iv, cs);
	}
	function setRecoveryData(uint32 answerId, bytes recoveryData) public pure {
		address addr = address.makeAddrStd(DEBOT_WC, ID);
		ISecurityCardManagement(addr).setRecoveryData(answerId, recoveryData);
	}
	function getRecoveryData(uint32 answerId) public pure {
		address addr = address.makeAddrStd(DEBOT_WC, ID);
		ISecurityCardManagement(addr).getRecoveryData(answerId);
	}

}

contract SecurityCardManagementABI is ISecurityCardManagement {
    function getBlockHashes(uint32 answerId, uint192 sn) external override returns (uint256 h2, uint256 h3) {}
    function turnOnWallet(uint32 answerId, uint192 sn, uint128 p1, uint16 iv, uint32 cs) external override returns (uint256 pubkey) {}
    function setRecoveryData(uint32 answerId, bytes recoveryData) external override returns (bool result) {}
    function getRecoveryData(uint32 answerId) external override returns (bytes recoveryData) {}
}
