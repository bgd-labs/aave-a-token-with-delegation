// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {IPool, ATokenWithDelegation} from '../src/contracts/ATokenWithDelegation.sol';
import {IGovernancePowerDelegationToken} from 'aave-token-v3/interfaces/IGovernancePowerDelegationToken.sol';
import {AaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
import {AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {IBaseAdminUpgradeabilityProxy} from './IBaseAdminUpgradeabilityProxy.sol';

contract PoolMock {
  address public constant ADDRESSES_PROVIDER = address(12351);
}

contract ATokenWithDelegationIntegrationTest is Test {
  address constant USER_1 = address(123);
  address constant USER_2 = address(1234);

  uint256 constant INDEX = 1e27;
  uint256 constant AMOUNT = 100 ether;

  ATokenWithDelegation aToken;
  address pool;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 16931880);

    pool = address(new PoolMock());
    ATokenWithDelegation aTokenImpl = new ATokenWithDelegation(IPool(pool));

    vm.prank(AaveGovernanceV2.SHORT_EXECUTOR);
    IBaseAdminUpgradeabilityProxy(address(AaveV3EthereumAssets.AAVE_A_TOKEN)).upgradeTo(
      address(aTokenImpl)
    );
  }

  function testMintDoesNotGiveDelegation() public {
    hoax(pool);
    aToken.mint(USER_1, USER_1, AMOUNT, INDEX);

    (uint256 votingPower, uint256 propositionPower) = aToken.getPowersCurrent(USER_1);

    assertEq(votingPower, AMOUNT);
    assertEq(propositionPower, AMOUNT);
  }
}
