// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {ATokenWithDelegation, IATokenWithDelegation, IGovernancePowerDelegationToken} from '../src/contracts/ATokenWithDelegation.sol';
import {DelegationBaseTest} from './DelegationBaseTest.sol';

contract ATokenWithDelegationTest is DelegationBaseTest {
  address constant USER_1 = address(123);
  address constant USER_2 = address(1234);
  address constant USER_3 = address(12345);
  address constant USER_4 = address(123456);

  // ----------------------------------------------------------------------------------------------
  //                       INTERNAL METHODS
  // ----------------------------------------------------------------------------------------------

  // TEST _governancePowerTransferByType
  function test_governancePowerTransferByTypeVoting()
    public
    mintAmount(USER_2)
    validateUserTokenBalance(USER_2)
  {
    uint72 delegationVotingPowerBefore = _getDelegationBalanceByType(
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    );

    uint104 impactOnDelegationBefore = uint104(0 ether);
    uint104 impactOnDelegationAfter = uint104(10 ether);

    _governancePowerTransferByType(
      impactOnDelegationBefore,
      impactOnDelegationAfter,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    );

    uint72 delegationVotingPowerAfter = _getDelegationBalanceByType(
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    );

    assertEq(
      delegationVotingPowerAfter,
      delegationVotingPowerBefore -
        uint72(impactOnDelegationBefore / POWER_SCALE_FACTOR) +
        uint72(impactOnDelegationAfter / POWER_SCALE_FACTOR)
    );
  }

  function test_governancePowerTransferByTypeProposition()
    public
    mintAmount(USER_2)
    validateUserTokenBalance(USER_2)
  {
    uint72 delegationPropositionPowerBefore = _getDelegationBalanceByType(
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    );

    uint104 impactOnDelegationBefore = uint104(0 ether);
    uint104 impactOnDelegationAfter = uint104(10 ether);

    _governancePowerTransferByType(
      impactOnDelegationBefore,
      impactOnDelegationAfter,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    );

    uint72 delegationPropositionPowerAfter = _getDelegationBalanceByType(
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    );

    assertEq(
      delegationPropositionPowerAfter,
      delegationPropositionPowerBefore -
        uint72(impactOnDelegationBefore / POWER_SCALE_FACTOR) +
        uint72(impactOnDelegationAfter / POWER_SCALE_FACTOR)
    );
  }

  function test_governancePowerTransferByTypeWhenDelegationReceiverIsAddress0()
    public
    validateNoChangesInDelegationBalanceByType(
      address(0),
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    )
  {
    uint104 impactOnDelegationBefore = uint104(1 ether);
    uint104 impactOnDelegationAfter = uint104(12 ether);
    _governancePowerTransferByType(
      impactOnDelegationBefore,
      impactOnDelegationAfter,
      address(0),
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    );
  }

  function test_governancePowerTransferByTypeWhenSameImpact()
    public
    mintAmount(USER_2)
    validateNoChangesInDelegationBalanceByType(
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    )
    validateUserTokenBalance(USER_2)
  {
    uint104 impactOnDelegationBefore = uint104(12 ether);
    uint104 impactOnDelegationAfter = uint104(12 ether);
    _governancePowerTransferByType(
      impactOnDelegationBefore,
      impactOnDelegationAfter,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    );
  }

  // TEST _transferWithDelegation
  function test_transferWithDelegation()
    public
    mintAmount(USER_1)
    mintAmount(USER_2)
    prepareDelegationToReceiver(USER_1, USER_3)
    prepareDelegationToReceiver(USER_2, USER_4)
    validateUserTokenBalance(USER_1)
    validateUserTokenBalance(USER_2)
    validateNoChangesInDelegationState(USER_1)
    validateNoChangesInDelegationState(USER_2)
    validateDelegationPower(
      USER_1,
      USER_4,
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    )
    validateDelegationPower(
      USER_1,
      USER_4,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    )
  {
    _transferWithDelegation(USER_1, USER_2, AMOUNT);
  }

  function test_transferWithDelegationFromNot0AndBalanceLtAmount()
    public
    mintAmount(USER_1)
    validateUserTokenBalance(USER_1)
    validateUserTokenBalance(USER_2)
    validateNoChangesInDelegation(USER_1)
    validateNoChangesInDelegation(USER_2)
  {
    uint256 amount = AMOUNT + 10;
    vm.expectRevert(bytes('ERC20: transfer amount exceeds balance'));
    _transferWithDelegation(USER_1, USER_2, amount);
  }

  function test_transferWithDelegationWhenFromEqTo()
    public
    mintAmount(USER_1)
    validateUserTokenBalance(USER_1)
    validateUserTokenBalance(USER_2)
    validateNoChangesInDelegation(USER_1)
    validateNoChangesInDelegation(USER_2)
  {
    _transferWithDelegation(USER_1, USER_1, AMOUNT);
  }

  function test_transferWithDelegationWhenFromEq0()
    public
    mintAmount(address(0))
    mintAmount(USER_1)
    validateUserTokenBalance(USER_1)
    prepareDelegationToReceiver(USER_1, USER_3)
    validateDelegationPower(
      address(0),
      USER_3,
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    )
    validateDelegationPower(
      address(0),
      USER_3,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    )
  {
    _transferWithDelegation(address(0), USER_1, AMOUNT);
  }

  function test_transferWithDelegationWhenToEq0()
    public
    mintAmount(USER_1)
    validateUserTokenBalance(USER_1)
    validateUserTokenBalance(USER_2)
    prepareDelegationToReceiver(USER_1, USER_2)
    validateDelegationRemoved(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    )
    validateDelegationRemoved(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    )
  {
    _transferWithDelegation(USER_1, address(0), AMOUNT);
  }

  // test that delegation does not chain
  function test_transferWithDelegationWhenFromNotDelegating()
    public
    mintAmount(USER_1)
    mintAmount(USER_2)
    validateUserTokenBalance(USER_1)
    validateUserTokenBalance(USER_2)
    prepareDelegationToReceiver(USER_2, USER_3)
    validateDelegationPower(
      USER_1,
      USER_3,
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    )
    validateDelegationPower(
      USER_1,
      USER_3,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    )
  {
    _transferWithDelegation(USER_1, USER_2, AMOUNT);
  }

  function test_transferWithDelegationWhenToNotDelegating()
    public
    mintAmount(USER_1)
    mintAmount(USER_2)
    validateUserTokenBalance(USER_1)
    validateUserTokenBalance(USER_2)
    validateNoChangesInDelegation(USER_2)
    prepareDelegationToReceiver(USER_1, USER_3)
    validateDelegationRemoved(
      USER_1,
      USER_3,
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    )
    validateDelegationRemoved(
      USER_1,
      USER_3,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    )
  {
    _transferWithDelegation(USER_1, USER_2, AMOUNT);
  }

  // TEST _getDelegatedPowerByType
  function test_getDelegatedPowerByType()
    public
    mintAmount(USER_1)
    prepareDelegationToReceiver(USER_1, USER_2)
  {
    uint256 delegatedVotingPower = _getDelegatedPowerByType(
      _delegatedBalances[USER_2],
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    );
    uint256 delegatedPropositionPower = _getDelegatedPowerByType(
      _delegatedBalances[USER_2],
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    );

    assertEq(delegatedVotingPower, uint256(_userState[USER_1].balance));
    assertEq(delegatedPropositionPower, uint256(_userState[USER_1].balance));
  }

  // TEST _getDelegateeByType
  function test_getDelegateeByType()
    public
    mintAmount(USER_1)
    prepareDelegationToReceiver(USER_1, USER_2)
  {
    address votingDelegatee = _getDelegateeByType(
      USER_1,
      _delegatedBalances[USER_1],
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    );
    address propositionDelegatee = _getDelegateeByType(
      USER_1,
      _delegatedBalances[USER_1],
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    );

    assertEq(votingDelegatee, USER_2);
    assertEq(propositionDelegatee, USER_2);
  }

  // TEST _updateDelegateeByType
  function test_updateDelegateeByTypeVoting()
    public
    validateDelegationReceiver(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    )
    validateDelegationReceiver(
      USER_1,
      address(0),
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    )
  {
    _updateDelegateeByType(
      USER_1,
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING,
      USER_2
    );
  }

  function test_updateDelegateeByTypeProposition()
    public
    validateDelegationReceiver(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    )
    validateDelegationReceiver(
      USER_1,
      address(0),
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    )
  {
    _updateDelegateeByType(
      USER_1,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION,
      USER_2
    );
  }

  // TEST _updateDelegationFlagByType
  function test_updateDelegationFlagByTypeVotingFromNoDelegation()
    public
    validateNoChangesInDelegation(USER_1)
  {
    IATokenWithDelegation.DelegationAwareBalance
      memory delegationBalance = _updateDelegationFlagByType(
        _delegatedBalances[USER_1],
        IGovernancePowerDelegationToken.GovernancePowerType.VOTING,
        true
      );

    assertEq(
      uint8(delegationBalance.delegationState),
      uint8(IATokenWithDelegation.DelegationState.VOTING_DELEGATED)
    );
  }

  function test_updateDelegationFlagByTypePropositionFromNoDelegation()
    public
    validateNoChangesInDelegation(USER_1)
  {
    IATokenWithDelegation.DelegationAwareBalance
      memory delegationBalance = _updateDelegationFlagByType(
        _delegatedBalances[USER_1],
        IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION,
        true
      );

    assertEq(
      uint8(delegationBalance.delegationState),
      uint8(IATokenWithDelegation.DelegationState.PROPOSITION_DELEGATED)
    );
  }

  function test_updateDelegationFlagByTypeVotingFromPropositionDelegation()
    public
    prepareDelegationByTypeToReceiver(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    )
    validateNoChangesInDelegation(USER_1)
  {
    IATokenWithDelegation.DelegationAwareBalance
      memory delegationBalance = _updateDelegationFlagByType(
        _delegatedBalances[USER_1],
        IGovernancePowerDelegationToken.GovernancePowerType.VOTING,
        true
      );

    assertEq(
      uint8(delegationBalance.delegationState),
      uint8(IATokenWithDelegation.DelegationState.FULL_POWER_DELEGATED)
    );
  }

  function test_updateDelegationFlagByTypePropositionFromVotingDelegation()
    public
    prepareDelegationByTypeToReceiver(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    )
    validateNoChangesInDelegation(USER_1)
  {
    IATokenWithDelegation.DelegationAwareBalance
      memory delegationBalance = _updateDelegationFlagByType(
        _delegatedBalances[USER_1],
        IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION,
        true
      );

    assertEq(
      uint8(delegationBalance.delegationState),
      uint8(IATokenWithDelegation.DelegationState.FULL_POWER_DELEGATED)
    );
  }

  function test_updateDelegationFlagByTypeRemoveVotingFromVoting()
    public
    prepareDelegationByTypeToReceiver(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    )
    validateNoChangesInDelegation(USER_1)
  {
    IATokenWithDelegation.DelegationAwareBalance
      memory delegationBalance = _updateDelegationFlagByType(
        _delegatedBalances[USER_1],
        IGovernancePowerDelegationToken.GovernancePowerType.VOTING,
        false
      );

    assertEq(
      uint8(delegationBalance.delegationState),
      uint8(IATokenWithDelegation.DelegationState.NO_DELEGATION)
    );
  }

  function test_updateDelegationFlagByTypeRemovePropositionFromProposition()
    public
    prepareDelegationByTypeToReceiver(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    )
    validateNoChangesInDelegation(USER_1)
  {
    IATokenWithDelegation.DelegationAwareBalance
      memory delegationBalance = _updateDelegationFlagByType(
        _delegatedBalances[USER_1],
        IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION,
        false
      );

    assertEq(
      uint8(delegationBalance.delegationState),
      uint8(IATokenWithDelegation.DelegationState.NO_DELEGATION)
    );
  }

  function test_updateDelegationFlagByTypeRemoveVotingFromFullDelegation()
    public
    prepareDelegationToReceiver(USER_1, USER_2)
    validateNoChangesInDelegation(USER_1)
  {
    IATokenWithDelegation.DelegationAwareBalance
      memory delegationBalance = _updateDelegationFlagByType(
        _delegatedBalances[USER_1],
        IGovernancePowerDelegationToken.GovernancePowerType.VOTING,
        false
      );

    assertEq(
      uint8(delegationBalance.delegationState),
      uint8(IATokenWithDelegation.DelegationState.PROPOSITION_DELEGATED)
    );
  }

  function test_updateDelegationFlagByTypeRemovePropositionFromFullDelegation()
    public
    prepareDelegationToReceiver(USER_1, USER_2)
    validateNoChangesInDelegation(USER_1)
  {
    IATokenWithDelegation.DelegationAwareBalance
      memory delegationBalance = _updateDelegationFlagByType(
        _delegatedBalances[USER_1],
        IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION,
        false
      );

    assertEq(
      uint8(delegationBalance.delegationState),
      uint8(IATokenWithDelegation.DelegationState.VOTING_DELEGATED)
    );
  }

  // TEST _delegateByType
  function test_delegateByTypeVoting()
    public
    mintAmount(USER_1)
    validateDelegationPower(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    )
    validateDelegationState(USER_1, USER_2, DelegationType.VOTING)
    validateDelegationReceiver(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    )
    validateUserTokenBalance(USER_1)
    validateUserTokenBalance(USER_2)
  {
    vm.expectEmit(true, true, false, true);
    emit DelegateChanged(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    );
    _delegateByType(USER_1, USER_2, IGovernancePowerDelegationToken.GovernancePowerType.VOTING);
  }

  function test_delegateByTypeProposition()
    public
    mintAmount(USER_1)
    validateDelegationPower(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    )
    validateDelegationState(USER_1, USER_2, DelegationType.PROPOSITION)
    validateDelegationReceiver(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    )
    validateUserTokenBalance(USER_1)
    validateUserTokenBalance(USER_2)
  {
    vm.expectEmit(true, true, false, true);
    emit DelegateChanged(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    );
    _delegateByType(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    );
  }

  function test_delegateByTypeToCurrentDelegatee()
    public
    mintAmount(USER_1)
    prepareDelegationToReceiver(USER_1, USER_2)
    validateNoChangesInDelegation(USER_1)
    validateNoChangesInDelegation(USER_2)
    validateUserTokenBalance(USER_1)
    validateUserTokenBalance(USER_2)
  {
    _delegateByType(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    );
  }

  function test_delegateByTypeToSelf()
    public
    mintAmount(USER_1)
    prepareDelegationByTypeToReceiver(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    )
    validateDelegationRemoved(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    )
    validateUserTokenBalance(USER_1)
    validateUserTokenBalance(USER_2)
  {
    vm.expectEmit(true, true, false, true);
    emit DelegateChanged(
      USER_1,
      address(0),
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    );
    _delegateByType(
      USER_1,
      USER_1,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    );
  }

  // ----------------------------------------------------------------------------------------------
  //                       EXTERNAL METHODS
  // ----------------------------------------------------------------------------------------------
  // TEST delegateByType
  function testDelegateByTypeVoting()
    public
    mintAmount(USER_1)
    validateDelegationPower(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    )
    validateDelegationState(USER_1, USER_2, DelegationType.VOTING)
    validateDelegationReceiver(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    )
    validateUserTokenBalance(USER_1)
    validateUserTokenBalance(USER_2)
  {
    hoax(USER_1);
    vm.expectEmit(true, true, false, true);
    emit DelegateChanged(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    );
    this.delegateByType(USER_2, IGovernancePowerDelegationToken.GovernancePowerType.VOTING);
  }

  function testDelegateByTypeProposition()
    public
    mintAmount(USER_1)
    validateDelegationPower(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    )
    validateDelegationState(USER_1, USER_2, DelegationType.PROPOSITION)
    validateDelegationReceiver(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    )
    validateUserTokenBalance(USER_1)
    validateUserTokenBalance(USER_2)
  {
    hoax(USER_1);
    vm.expectEmit(true, true, false, true);
    emit DelegateChanged(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    );
    this.delegateByType(USER_2, IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION);
  }

  function testDelegateByTypeToCurrentDelegatee()
    public
    mintAmount(USER_1)
    prepareDelegationToReceiver(USER_1, USER_2)
    validateNoChangesInDelegation(USER_1)
    validateNoChangesInDelegation(USER_2)
    validateUserTokenBalance(USER_1)
    validateUserTokenBalance(USER_2)
  {
    hoax(USER_1);
    this.delegateByType(USER_2, IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION);
  }

  function testDelegateByTypeToSelf()
    public
    mintAmount(USER_1)
    prepareDelegationByTypeToReceiver(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    )
    validateDelegationRemoved(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    )
    validateUserTokenBalance(USER_1)
    validateUserTokenBalance(USER_2)
  {
    hoax(USER_1);
    vm.expectEmit(true, true, false, true);
    emit DelegateChanged(
      USER_1,
      address(0),
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    );
    this.delegateByType(USER_1, IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION);
  }

  // TEST delegate
  function testDelegate()
    public
    mintAmount(USER_1)
    validateDelegationPower(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    )
    validateDelegationPower(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    )
    validateDelegationState(USER_1, USER_2, DelegationType.FULL_POWER)
    validateDelegationReceiver(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    )
    validateDelegationReceiver(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    )
    validateUserTokenBalance(USER_1)
    validateUserTokenBalance(USER_2)
  {
    hoax(USER_1);
    vm.expectEmit(true, true, false, true);
    emit DelegateChanged(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    );
    vm.expectEmit(true, true, false, true);
    emit DelegateChanged(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    );
    this.delegate(USER_2);
  }

  function testDelegateToCurrentDelegatee()
    public
    mintAmount(USER_1)
    prepareDelegationToReceiver(USER_1, USER_2)
    validateNoChangesInDelegation(USER_1)
    validateNoChangesInDelegation(USER_2)
    validateUserTokenBalance(USER_1)
    validateUserTokenBalance(USER_2)
  {
    hoax(USER_1);
    this.delegate(USER_2);
  }

  function testDelegateToSelf()
    public
    mintAmount(USER_1)
    prepareDelegationToReceiver(USER_1, USER_2)
    validateDelegationRemoved(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    )
    validateDelegationRemoved(
      USER_1,
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    )
    validateUserTokenBalance(USER_1)
    validateUserTokenBalance(USER_2)
  {
    hoax(USER_1);
    vm.expectEmit(true, true, false, true);
    emit DelegateChanged(
      USER_1,
      address(0),
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    );
    emit DelegateChanged(
      USER_1,
      address(0),
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    );

    this.delegate(USER_1);
  }

  // TEST getDelegateeByType
  function testGetDelegateeByType()
    public
    mintAmount(USER_1)
    prepareDelegationToReceiver(USER_1, USER_2)
  {
    address votingDelegatee = this.getDelegateeByType(
      USER_1,
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    );
    address propositionDelegatee = this.getDelegateeByType(
      USER_1,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    );

    assertEq(votingDelegatee, USER_2);
    assertEq(propositionDelegatee, USER_2);
  }

  // TEST getDelegates
  function testGetDelegates()
    public
    mintAmount(USER_1)
    prepareDelegationToReceiver(USER_1, USER_2)
  {
    (address votingDelegatee, address propositionDelegatee) = this.getDelegates(USER_1);

    assertEq(votingDelegatee, USER_2);
    assertEq(propositionDelegatee, USER_2);
  }

  // TEST getPowerCurrent
  function testGetPowerCurrent()
    public
    mintAmount(USER_1)
    prepareDelegationToReceiver(USER_1, USER_2)
  {
    uint256 votingPower = this.getPowerCurrent(
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    );

    uint256 propositionPower = this.getPowerCurrent(
      USER_2,
      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    );

    assertEq(
      votingPower,
      uint256(_delegatedBalances[USER_2].delegatedVotingBalance * POWER_SCALE_FACTOR)
    );

    assertEq(
      propositionPower,
      uint256(_delegatedBalances[USER_2].delegatedPropositionBalance * POWER_SCALE_FACTOR)
    );
  }

  // TEST getPowersCurrent
  function testGetPowersCurrent()
    public
    mintAmount(USER_1)
    prepareDelegationToReceiver(USER_1, USER_2)
  {
    (uint256 votingPower, uint256 propositionPower) = this.getPowersCurrent(USER_2);

    assertEq(
      votingPower,
      uint256(_delegatedBalances[USER_2].delegatedVotingBalance * POWER_SCALE_FACTOR)
    );

    assertEq(
      propositionPower,
      uint256(_delegatedBalances[USER_2].delegatedPropositionBalance * POWER_SCALE_FACTOR)
    );
  }
}
