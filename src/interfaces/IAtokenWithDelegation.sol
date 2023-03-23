// SPDX-License-Identifier: BUSL-1.1
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
}
