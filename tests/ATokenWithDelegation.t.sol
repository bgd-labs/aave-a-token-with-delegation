// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {ATokenWithDelegation, IATokenWithDelegation, IGovernancePowerDelegationToken} from '../src/contracts/ATokenWithDelegation.sol';
import {DelegationBaseTest} from './DelegationBaseTest.sol';

contract ATokenWithDelegationTest is DelegationBaseTest {
  address constant USER_1 = address(123);
  address constant USER_2 = address(1234);
  address constant USER_3 = address(12345);

  // TEST _governancePowerTransferByType
  function testGovernancePowerTransferByTypeVoting()
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

  function testGovernancePowerTransferByTypeProposition()
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

  function testGovernancePowerTransferByTypeWhenDelegationReceiverIsAddress0()
    public
    validateNoChangesInDelegation(
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

  function testGovernancePowerTransferByTypeWhenSameImpact()
    public
    mintAmount(USER_2)
    validateNoChangesInDelegation(
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
  function testTransferWithDelegation()
    public
    mintAmount(USER_1)
    mintAmount(USER_2)
    prepareDelegationToReceiver(USER_1, USER_3)
    //    validateDelegationReceiver(
    //      USER_1,
    //      USER_2,
    //      IGovernancePowerDelegationToken.GovernancePowerType.VOTING
    //    )
    //    validateDelegationReceiver(
    //      USER_1,
    //      USER_2,
    //      IGovernancePowerDelegationToken.GovernancePowerType.PROPOSITION
    //    )
    validateUserTokenBalance(USER_1)
    validateUserTokenBalance(USER_2)
    validateNoChangesInDelegationState(USER_1)
    validateNoChangesInDelegationState(USER_2)
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
  {
    _transferWithDelegation(USER_1, USER_2, AMOUNT);
  }

  function testTransferWithDelegationFromNot0AndBalanceGtAmount() public {}

  function testTransferWithDelegationWhenFromEqTo() public {}

  function testTransferWithDelegationWhenFromEq0() public {}

  function testTransferWithDelegationWhenToEq0() public {}

  function testTransferWithDelegationWhenFromNotDelegating() public {}

  function testTransferWithDelegationWhenToNotDelegating() public {}

  // TEST _delegateByType
  function testDelegateTypeVotingPowerToUser()
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
    _delegateByType(USER_1, USER_2, IGovernancePowerDelegationToken.GovernancePowerType.VOTING);
  }
}
