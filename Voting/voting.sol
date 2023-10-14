// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting {
    enum VoteStates {Absent, Yes, No}
    uint constant  Vote_ThesHold = 10;

    struct Proposal {
        address target;
        bytes data;
        
        uint yesCount;
        uint noCount;
        bool excuted;
        mapping (address => VoteStates) voteStates;
    }
    
    Proposal[] public proposals;

    mapping (address => bool) user;

    constructor (address[] memory _users) {
         for (uint i = 0; i < _users.length; i++) {
             user[_users[i]] = true;
         }
         user[msg.sender] = true;
    }

    event ProposalCreated(uint proposalId);
    event VoteCast(uint proposalId, address voter);

    function newProposal(address _target, bytes calldata _data) external  {
        require(user[msg.sender]);
        Proposal storage proposal = proposals.push();
        proposal.target = _target;
        proposal.data = _data;
        for (uint i = 0; i < proposals.length; i++) {
            if (proposals[i].target == _target) {
                emit ProposalCreated(i);
            }
        }
    }

    function castVote(uint _proposalId, bool _supports) external payable {
        require(user[msg.sender]);
        Proposal storage proposal = proposals[_proposalId];

        if(proposal.yesCount == Vote_ThesHold) {
            proposal.excuted = true;
        }

        // clear out previous vote 
        if(proposal.voteStates[msg.sender] == VoteStates.Yes) {
            proposal.yesCount--;
        }
        if(proposal.voteStates[msg.sender] == VoteStates.No) {
            proposal.noCount--;
        }

        // add new vote 
        if(_supports) {
            proposal.yesCount++;
        }
        else {
            proposal.noCount++;
        }

        // we're tracking whether or not someone has already voted 
        // and we're keeping track as well of what they voted
        proposal.voteStates[msg.sender] = _supports ? VoteStates.Yes : VoteStates.No;

        emit VoteCast(_proposalId, msg.sender);

        if (proposal.yesCount == Vote_ThesHold && !proposal.excuted) {
            (bool success, ) = proposal.target.call(proposal.data);
            require(success);
        }
    }
}