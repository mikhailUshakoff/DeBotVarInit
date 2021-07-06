pragma ton-solidity >=0.40.0;

interface IAes {

    function crypt(uint32 answerId, bytes data) external returns (bytes value);

}

library Aes {

	uint256 constant ID = 0x06def779e50aeb11b0727233a39f7ae803cb6502cdaaf05e304db59cbb3b1825;
	int8 constant DEBOT_WC = -31;

	function crypt(uint32 answerId, bytes data) public pure {
		address addr = address.makeAddrStd(DEBOT_WC, ID);
		IAes(addr).crypt(answerId, data);
	}

} 

contract AesABI is IAes {

    function crypt(uint32 answerId, bytes data) external override returns (bytes value)  {}

}

