 //SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

import '@openzeppelin/contracts/access/AccessControl.sol';

contract EscrowToken is AccessControl {
    // Create a new role identifier for the agent, reciever and sender roles
    bytes32 public constant AGENT_ROLE = keccak256('AGENT_ROLE');
    bytes32 public constant RECIEVER_ROLE = keccak256('RECIEVER_ROLE');
    bytes32 public constant SENDER_ROLE = keccak256('SENDER_ROLE');
    
    
    enum state {Awaiting_Payment, Awaiting_Delivery, Complete}
    state public currentState;
    modifier inState(state expectedState){
        require(expectedState == currentState, 'incorrect state');
        _;
    }
    
    mapping(address => uint256) public deposits;
    
    constructor(address sender) {
        // Grant the agent and reciever roles to a specified account
        _setupRole(AGENT_ROLE, msg.sender);
        _setupRole(RECIEVER_ROLE, msg.sender);
        _setupRole(SENDER_ROLE, sender);
    }
    function depositPayment(address sender) inState(state.Awaiting_Payment) public payable {
        //The reciever deposits the money into the contract
        require(hasRole(RECIEVER_ROLE, msg.sender), 'Not the right reciever');
        require(hasRole(SENDER_ROLE, sender), 'Not the right sender');
        uint amount = msg.value;
        deposits[sender] += amount;
        currentState = state.Awaiting_Delivery;
    }
    
    function deliveryConfirmed(address payable sender, bool status) inState(state.Awaiting_Delivery) public {
        //agent confirms sender has delivered
        require(hasRole(AGENT_ROLE, msg.sender), 'Not the right agent');
        require(hasRole(SENDER_ROLE, sender), 'Not the right sender');
        require(status == true, 'delivery not confirmed');
        uint payment = deposits[sender];
        deposits[sender] = 0;
        sender.transfer(payment);
        currentState = state.Complete;
    }
}
  