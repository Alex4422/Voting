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
    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }

    //the proposal which has the more votes
    uint public winningProposalID;

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

    function Voting(){

    }
}
