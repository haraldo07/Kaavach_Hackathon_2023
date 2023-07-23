// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

contract SpamData {
    uint public entryCount;
    mapping(uint => Entry) public entries;

    struct Entry {
        uint id;
        address payable user;
        string entryType;
        string description;
        bool isValidated;
    }

    event EntryCreated(
        uint id,
        address payable user,
        string entryType,
        string description,
        bool isValidated
    );

    event EntryValidated(
        uint id,
        bool isValidated
    );

    function reportSpam(string memory _entryType, string memory _description) public payable {
        require(msg.value > 0, "A fee is required to report spam.");
        entryCount++;
        entries[entryCount] = Entry(entryCount, payable(msg.sender), _entryType, _description, false);
        emit EntryCreated(entryCount, payable(msg.sender), _entryType, _description, false);
    }

    function validateEntry(uint _id) public {
        Entry memory _entry = entries[_id];
        require(_entry.user == msg.sender, "Only the user who created the entry can validate it.");
        require(!_entry.isValidated, "The entry has already been validated.");
        entries[_id].isValidated = true;
        _entry.user.transfer(address(this).balance);
        emit EntryValidated(_id, true);
    }
}
