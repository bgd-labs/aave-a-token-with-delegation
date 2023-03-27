// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {IPool, ATokenWithDelegation, IATokenWithDelegation, IGovernancePowerDelegationToken} from '../src/contracts/ATokenWithDelegation.sol';

contract PoolMock {
  address public constant ADDRESSES_PROVIDER = address(12351);
}

contract DelegationBaseTest is Test, ATokenWithDelegation {
  uint256 constant INDEX = 1e27;

  constructor() ATokenWithDelegation(IPool(address(new PoolMock()))) {}

  enum DelegationType {
    VOTING,
    PROPOSITIN,
    FULL_POWER
  }

  modifier mintAmount(address caller) {
    uint256 amountToMint = 100 ether;

    hoax(address(POOL));
    this.mint(caller, caller, amountToMint, INDEX);
    _;
  }

  // validates no changes happened in delegation balance for a user and delegation type
  modifier validateNoChanges(
    address user,
    IGovernancePowerDelegationToken.GovernancePowerType delegationType
  ) {
    uint104 beforeDelegationPowerOfUser = _getDelegationBalanceByType(user, delegationType);

    _;

    uint104 afterDelegationPowerOfUser = _getDelegationBalanceByType(user, delegationType);

    // ----------------------------- VALIDATIONS ----------------------------------------------
    assertEq(beforeDelegationPowerOfUser, afterDelegationPowerOfUser);
  }

  modifier validateUserTokenBalance(address user) {
    uint128 beforeDelegationActualBalanceOfDelegator = _getHolderActualBalance(user);

    _;
    uint128 afterDelegationActualBalanceOfDelegator = _getHolderActualBalance(user);

    // ----------------------------- VALIDATIONS ----------------------------------------------
    // actual a token balance should not have changed
    assertEq(beforeDelegationActualBalanceOfDelegator, afterDelegationActualBalanceOfDelegator);
  }

  // validates that the balance of delegator is now being delegated to recipient
  modifier validateDelegationPower(
    address delegator,
    address delegationRecipient,
    IGovernancePowerDelegationToken.GovernancePowerType delegationType
  ) {
    uint128 beforeDelegationActualBalanceOfDelegator = _getHolderActualBalance(delegator);

    uint104 beforeDelegationPowerOfDelegator = _getDelegationBalanceByType(
      delegator,
      delegationType
    );
    uint104 beforeDelegationPowerOfDelegationRecipient = _getDelegationBalanceByType(
      delegationRecipient,
      delegationType
    );

    _;

    uint104 afterDelegationPowerOfDelegator = _getDelegationBalanceByType(
      delegator,
      delegationType
    );
    uint104 afterDelegationPowerOfDelegationRecipient = _getDelegationBalanceByType(
      delegationRecipient,
      delegationType
    );

    // balance of delegator moved to delegation recipient
    assertEq(afterDelegationPowerOfDelegator, 0);
    assertEq(
      afterDelegationPowerOfDelegationRecipient,
      uint72(beforeDelegationActualBalanceOfDelegator / POWER_SCALE_FACTOR) +
        beforeDelegationPowerOfDelegator
    );
  }

  // validates that delegator delegation state changes accordingly
  modifier validateDelegationState(
    address delegator,
    address delegationRecipient,
    DelegationType delegationType
  ) {
    IATokenWithDelegation.DelegationState beforeDelegationStateOfDelegationRecipient = _getDelegationState(
        delegationRecipient
      );

    _;

    IATokenWithDelegation.DelegationState afterDelegationStateOfDelegator = _getDelegationState(
      delegator
    );
    IATokenWithDelegation.DelegationState afterDelegationStateOfDelegationRecipient = _getDelegationState(
        delegationRecipient
      );

    // ----------------------------- VALIDATIONS ----------------------------------------------
    if (delegationType == DelegationType.FULL_POWER) {
      assertEq(
        uint8(afterDelegationStateOfDelegator),
        uint8(IATokenWithDelegation.DelegationState.FULL_POWER_DELEGATED)
      );
    } else if (delegationType == DelegationType.VOTING) {
      assertEq(
        uint8(afterDelegationStateOfDelegator),
        uint8(IATokenWithDelegation.DelegationState.VOTING_DELEGATED)
      );
    } else {
      assertEq(
        uint8(afterDelegationStateOfDelegator),
        uint8(IATokenWithDelegation.DelegationState.PROPOSITION_DELEGATED)
      );
    }
    assertEq(
      uint8(beforeDelegationStateOfDelegationRecipient),
      uint8(afterDelegationStateOfDelegationRecipient)
    );
  }

  modifier validateDelegationReceiver(
    address delegator,
    address delegationReceiver,
    IGovernancePowerDelegationToken.GovernancePowerType delegationType
  ) {
    _;
    if (delegationType == IGovernancePowerDelegationToken.GovernancePowerType.VOTING) {
      assertEq(_votingDelegateeV2[delegator], delegationReceiver);
    } else {
      assertEq(_propositionDelegateeV2[delegator], delegationReceiver);
    }
  }

  function _getHolderActualBalance(address holder) internal returns (uint128) {
    return _userState[holder].balance;
  }

  function _getDelegationBalanceByType(
    address holder,
    IGovernancePowerDelegationToken.GovernancePowerType delegationType
  ) internal returns (uint72) {
    if (delegationType == IGovernancePowerDelegationToken.GovernancePowerType.VOTING) {
      return _delegatedBalances[holder].delegatedVotingBalance;
    } else {
      return _delegatedBalances[holder].delegatedPropositionBalance;
    }
  }

  function _getDelegationState(
    address holder
  ) internal returns (IATokenWithDelegation.DelegationState) {
    return _delegatedBalances[holder].delegationState;
  }
}
