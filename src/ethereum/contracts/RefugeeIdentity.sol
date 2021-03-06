pragma solidity ^0.4.17;

import "./OwnerIdentity.sol";

contract RefugeeIdentity is OwnerIdentity {
   
   uint counter = 0;
   
   struct Person {
       uint id;
       bytes32 fullName;
       bytes32 origin;
       bytes32 organization;
       bytes32 ipfsFirst;
       bytes32 ipfsSecond;
   }
   
   struct PersonWithUport {
       uint id;
       bool exists;
   }

   event eventPersonAdded(string msg, uint id);
   event eventPersonEdited(string msg, uint id);
   event eventGetPerson(string msg, uint id);
   event eventtransferIdentityOwnership(string msg, uint id);
   
    mapping(uint => Person) people;
    
    mapping(address => PersonWithUport) peopleWithUport;
    
    modifier _ownerDoenstExist(address _address)  {
        require(!peopleWithUport[_address].exists);
        _;
    }
    
    function addPerson(bytes32 _fullName, bytes32 _origin, bytes32 _organization, bytes32 _ipfs1, bytes32 _ipfs2) public _adminOnly() payable {
        people[counter] = Person(counter, _fullName, _origin, _organization, _ipfs1, _ipfs2);
        eventPersonAdded("New person added successfully.", ++counter);
    }
    
     function editPerson(uint _id, bytes32 _fullName, bytes32 _origin, bytes32 _organization, bytes32 _ipfs1, bytes32 _ipfs2) public  payable {
        if ((peopleWithUport[msg.sender].exists || admins[msg.sender]) && counter < _id) {
            people[_id] = Person(_id, _fullName, _origin, _organization, _ipfs1, _ipfs2);
            eventPersonEdited("Person data edited successfully.", _id);
        } else {
            eventPersonEdited("Error looking up person.", _id);
            assert(counter > _id);
        }
    }
    
    function getOnePersonById(uint _id) public view returns(uint, bytes32, bytes32, bytes32, bytes32, bytes32) {
        if (counter > _id) {
            return (people[_id].id, people[_id].fullName, people[_id].origin, people[_id].organization, people[_id].ipfsFirst, people[_id].ipfsSecond);
        } else {
            eventGetPerson("Invalid ID used for lookup", _id);
            assert(counter < _id);
        }
    }
    
    function getAll() public view returns(uint[], bytes32[], bytes32[], bytes32[], bytes32[], bytes32[]) {
        
        uint[] memory ids = new uint[](counter);
        bytes32[] memory names = new bytes32[](counter);
        bytes32[] memory origins = new bytes32[](counter);
        bytes32[] memory organizations = new bytes32[](counter);
        bytes32[] memory ipfsOne = new bytes32[](counter);
        bytes32[] memory ipfsTwo = new bytes32[](counter);
        
        for (uint i = 0; i < counter; i++) {
            ids[i] = people[i].id;
            names[i] = people[i].fullName;
            origins[i] = people[i].origin;
            organizations[i] = people[i].organization;
            ipfsOne[i] = people[i].ipfsFirst;
            ipfsTwo[i] = people[i].ipfsSecond;
        }
        
        return (ids, names, origins, organizations, ipfsOne, ipfsTwo);
    }
    
    function transferIdentityOwnership(address _address, uint _id) public payable _adminOnly() _ownerDoenstExist(_address) returns(bool) {
        if (_id < counter) {
            peopleWithUport[_address] = PersonWithUport(_id, true);
            eventtransferIdentityOwnership("Identity owenership transfered", _id);
        } else {
            eventtransferIdentityOwnership("Error when trying to transfer identity owenership", _id);
            assert(_id > counter);
        }
    }
    
    function getCount() public view returns (uint) {
        return counter;
    }
    
}
