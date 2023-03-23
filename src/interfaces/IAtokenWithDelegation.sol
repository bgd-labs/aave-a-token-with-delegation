// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IATokenWithDelegation {
  enum DelegationState {
    NO_DELEGATION,
    VOTING_DELEGATED,
    PROPOSITION_DELEGATED,
    FULL_POWER_DELEGATED
  }

  struct DelegationAwareBalance {
    uint104 balance; // not used for now, but just in case in some moment we want to migrate
    uint72 delegatedPropositionBalance;
    uint72 delegatedVotingBalance;
    DelegationState delegationState;
  }

  function POWER_SCALE_FACTOR() external view returns (uint256);

  function DELEGATE_BY_TYPE_TYPEHASH() external view returns (bytes32);

  function DELEGATE_TYPEHASH() external view returns (bytes32);

  function DELEGATE_DOMAIN_SEPARATOR() external view returns (bytes32);
}
