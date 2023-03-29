// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {ATokenWithDelegation} from '../src/contracts/ATokenWithDelegation.sol';
import {IGovernancePowerDelegationToken} from 'aave-token-v3/interfaces/IGovernancePowerDelegationToken.sol';
import {AaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {BaseAdminUpgradeabilityProxy} from 'aave-v3-core/contracts/dependencies/openzeppelin/upgradeability/BaseAdminUpgradeabilityProxy.sol';

contract ATokenWithDelegationIntegrationTest is Test {
  address constant USER_1 = address(123);
  address constant USER_2 = address(1234);

  uint256 constant INDEX = 1e27;
  uint256 constant AMOUNT = 100 ether;

  ATokenWithDelegation aToken;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 16931880);

    ATokenWithDelegation aTokenImpl = new ATokenWithDelegation(AaveV3Ethereum.POOL);

    hoax(address(AaveV3Ethereum.POOL_CONFIGURATOR));
    BaseAdminUpgradeabilityProxy(payable(address(AaveV3EthereumAssets.AAVE_A_TOKEN))).upgradeTo(
      address(aTokenImpl)
    );
  }

  function testMintDoesNotGiveDelegation() public {
    hoax(address(AaveV3Ethereum.POOL));
    aToken.mint(USER_1, USER_1, AMOUNT, INDEX);

    (uint256 votingPower, uint256 propositionPower) = aToken.getPowersCurrent(USER_1);

    assertEq(votingPower, AMOUNT);
    assertEq(propositionPower, AMOUNT);
  }
}
