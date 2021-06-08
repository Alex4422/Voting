pragma solidity 0.8.4;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

/**
 * @title Voting
 * @dev Manages a voting system
 */
contract Voting is Ownable{

    //Structure to implement a voter
    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedProposalId;
    }

    //Structure to implement a proposal voted by the voters
    struct Proposal {
        string description;
        uint voteCount;
    }

    //mapping
    mapping (uint => Proposal) public proposals;
    mapping (address => Voter) public voters;



    //implementation of the different states during the process
    enum WorkflowStatus {RegisteringVoters, ProposalsRegistrationStarted,
        ProposalsRegistrationEnded, VotingSessionStarted, VotingSessionEnded, VotesTallied
    }

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

    //the proposal which has the more votes
    uint public winningProposalID;

    //The address of the admin of the contract
    address public ownerOfVotes;

    //the variable status contains the state of the worflow where I am !!!!!!!!
    WorkflowStatus status = WorkflowStatus.RegisteringVoters;

    constructor() public{
        ownerOfVotes = msg.sender;
    }

    //modifier
    modifier isRightWorkflowStatus(WorkflowStatus _expectedStatus){
        require(status == _expectedStatus, "This workflow status is not the one expected");
        _;
    }

    /**
       element: function
       title: registerVoter
       description: registers a voter in a whitelist - The voting administrator
        registers a white list of voters identified by their Ethereum address. Check if we are at
        the correct status at the beginning of the function
    */
    function registerVoter(address _voterAddress) public onlyOwner
    isRightWorkflowStatus(WorkflowStatus.RegisteringVoters){

        //if (voters[_voterAddress].isRegistered == false){
        require(voters[_voterAddress].isRegistered == false, "The voter is already Registered");
        voters[_voterAddress].isRegistered = true;
        emit VoterRegistered(_voterAddress);
    }

    /**
       element: function
       title: startProposalRegistrationSession
       description: start a new session of Registration proposal - The voting
        administrator begins the proposal registration session.
    */
    function startProposalRegistrationSession() public
    onlyOwner isRightWorkflowStatus(WorkflowStatus.RegisteringVoters) {

        status = WorkflowStatus.ProposalsRegistrationStarted;

        emit WorkflowStatusChange(WorkflowStatus.RegisteringVoters, status);
        emit ProposalsRegistrationStarted();
    }

    /**
       element: function
       title: registerProposal
       description: Registered voters are allowed to register their proposals (only !!) while the registration session is active.
    */
    function registerProposal(uint _proposalId, string memory _description )
    isRightWorkflowStatus(WorkflowStatus.ProposalsRegistrationStarted) public{

        proposals[_proposalId].description = _description;

        //no need to init here, proposals[_proposalId].voteCount = 0;, automatically done

        emit ProposalRegistered(_proposalId);
    }


    /**
        element: function
        title: endProposalRegistrationSession
        description: end a session of registration of a new proposal - The voting
        administrator closes the proposal registration session.
    */
    function endProposalRegistrationSession()
    onlyOwner isRightWorkflowStatus(WorkflowStatus.ProposalsRegistrationStarted) public{

        status = WorkflowStatus.ProposalsRegistrationEnded;

        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationStarted, status);
        emit ProposalsRegistrationEnded();
    }

    /**
        element: function
        title: VotingSessionStarted
        description: The voting administrator starts the voting session
    */
    function startVotingSession()
    onlyOwner isRightWorkflowStatus(WorkflowStatus.ProposalsRegistrationEnded) public{

        status = WorkflowStatus.VotingSessionStarted;

        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationEnded, status);
        emit VotingSessionStarted();
    }

    /**
        element: function
        title: doTheVote
        description: increments the voteCount of 1 for the proposal voted by the person
    */
    function doTheVote(address _voter, uint _proposalId)
    isRightWorkflowStatus(WorkflowStatus.VotingSessionStarted) public{

        require(voters[_voter].hasVoted == false, "The voter has already Voted");

        // we check if the ID of the proposal exists
        require(bytes(proposals[_proposalId].description).length != 0, "The ID of the proposal is not found!");

        voters[_voter].hasVoted = true;
        proposals[_proposalId].voteCount = proposals[_proposalId].voteCount + 1;
        voters[_voter].votedProposalId = _proposalId;
    }

    /**
        element: function
        title: EndVotingSession
        description: close the session of vote
    */
    function EndVotingSession()
    onlyOwner isRightWorkflowStatus(WorkflowStatus.VotingSessionStarted) public{

        status = WorkflowStatus.VotingSessionEnded;

        emit WorkflowStatusChange(WorkflowStatus.VotingSessionStarted, status);
        emit VotingSessionEnded();
    }
}

