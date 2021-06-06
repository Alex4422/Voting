// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.6.11;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

/**
 * @title Voting
 * @dev Manages a voting system
 */
contract Voting {

    //Structure to implement a voter
    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedProposalId;
    }

    //Structure to implement a proposal voted by the voters after
    struct Proposal {
        string description;
        uint voteCount;
    }

    //implementation of the different states during the process
    enum WorkflowStatus {RegisteringVoters, ProposalsRegistrationStarted,
        ProposalsRegistrationEnded, VotingSessionStarted, VotingSessionEnded, VotesTallied
    }

    //The address of the admin of the contract
    address public ownerOfVotes;

    //the proposal which has the more votes
    uint public winningProposalID;

    //mapping
    mapping (address => bool) public voterWhitelist;
    //mapping(address => WorkflowStatus) public workflowListStatus;
    //mapping(address => WorkflowStatus) state;



    //the different events of the application
    event VoterRegistered(address voterAddress);
    event ProposalsRegistrationStarted();
    event ProposalsRegistrationEnded();
    event ProposalRegistered(uint proposalId);
    event VotingSessionStarted();
    event VotingSessionEnded();
    event Voted (address voter, uint proposalId);
    event VotesTallied();
    event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus
    newStatus);


    modifier onlyOwnerOfVotes{
        require(msg.sender, "Only the owner for that!");
        _;
    }

    modifier onlyElectors{
        require(msg.sender, "only the electors for that");
        _;
    }

    constructor() public{
        ownerOfVotes = msg.sender;
        voterWhitelist[msg.sender] = true;
    }

    /**
        element: function
        title: registerVoter
        description: registers a voter in a whitelist
    */
    function registerVoter(address _voterAddress) public onlyOwnerOfVotes{
        require(voterWhitelist[_voterAddress] != WorkflowStatus.RegisteringVoters,"Voter already registered");
        voterWhitelist[_voterAddress] = WorkflowStatus.RegisteringVoters;

        emit VoterRegistered(_voterAddress);
    }

    /**
        element: function
        title: startProposalRegistrationSession
        description: start a new session of Registration proposal
    */
    function startProposalRegistrationSession(address _address) public onlyOwnerOfVotes{

        require(workflowListStatus[_address] == WorkflowStatus.RegisteringVoters,"The previous status is not correct to do this step");

        //WorkflowStatus status = WorkflowStatus.RegisteringVoters;
        WorkflowStatus status = WorkflowStatus.ProposalsRegistrationStarted;

        emit ProposalsRegistrationStarted();
        emit WorkflowStatusChange(WorkflowStatus.RegisteringVoters, status);
    }

    /**
        element: function
        title: registerProposal
        description: register a new proposal
    */
    function registerProposal(uint _proposalId) public onlyElectors{

        //We don't change the value of the status here because we are registering the proposals so the
        //session is not finished
        emit ProposalRegistered( _proposalId);

        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationStarted,status);
    }

    /**
        element: function
        title: endProposalRegistrationSession
        description: end a session of registration of a new proposal
    */
    function endProposalRegistrationSession(address _address) public onlyOwnerOfVotes{

        WorkflowStatus status = WorkflowStatus.ProposalsRegistrationStarted;
        status = WorkflowStatus.ProposalsRegistrationEnded;

        emit ProposalsRegistrationEnded();
        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationStarted, status);
    }
}
