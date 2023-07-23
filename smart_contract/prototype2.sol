pragma solidity ^0.8.0;

contract SpamData {
    
    address owner;
    mapping(address => uint) public balances;
    
    struct Spam {
        address user;
        string sType;
        string description;
        uint timestamp;
        uint riskScore;
    }
    
    Spam[] public spams;
    
    constructor() {
        owner = msg.sender;
    }
    
    function reportSpam(string memory sType, string memory description) public payable {
        require(msg.value > 0, "Please pay a fee to report spam.");
        uint reward = msg.value * 5 / 4;
        balances[msg.sender] += reward;
        spams.push(Spam(msg.sender, sType, description, block.timestamp, 0));
    }
    
    function classifySpam(uint spamIndex) public returns (uint) {
        require(msg.sender == owner, "Only the owner can classify spam.");
        require(spamIndex < spams.length, "Invalid spam index.");
        
        // Call the ML API to classify the spam
        uint riskScore = callMLAPI(spams[spamIndex].description);
        spams[spamIndex].riskScore = riskScore;
        
        return riskScore;
    }
    
    function callMLAPI(string memory description) private returns (uint) {
        // Call the ML API to classify the spam and return the risk score
        // This function would be implemented using an external API call in a production environment
        // For testing purposes, we can just return a random number between 0 and 100
        return uint(keccak256(abi.encodePacked(block.timestamp, description))) % 101;
    }
    
    function withdraw() public {
        uint amount = balances[msg.sender];
        require(amount > 0, "Insufficient balance.");
        balances[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
    
}

