pragma ton-solidity >= 0.44.0;
pragma AbiHeader time;
pragma AbiHeader pubkey;
pragma AbiHeader expire;

contract Device {
    
    uint256 static m_id;
    uint256 m_server;
    bytes m_data;

    constructor() public {
        m_server=0xff89275a5fc3a42dad52802c01abba6d0903acc7aeb6beccd076d912313b4fec;
    }

    function setData(bytes data) public {
        require(msg.pubkey()==m_server, 101);
        tvm.accept();
        m_data = data;
    }

    function getData() public view returns (bytes) {
        return m_data;
    }

    function getKey() public view returns (uint256) {
        return m_server;
    }

    function remove(address dest) public {
        tvm.accept();
		selfdestruct(dest);
	}
    
}