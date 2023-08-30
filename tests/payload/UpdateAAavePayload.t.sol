// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';
import {GovHelpers} from 'aave-helpers/GovHelpers.sol';
import {ProxyHelpers} from 'aave-helpers/ProxyHelpers.sol';
import {ATokenWithDelegation} from '../../src/contracts/ATokenWithDelegation.sol';
import {AaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';
import {UpdateAAavePayload} from '../../src/contracts/payload/UpdateAAavePayload.sol';

contract UpdateAAavePayloadTest is Test {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 17635720);
  }

  function testExecute() public {
    ATokenWithDelegation aAaveToken = new ATokenWithDelegation(AaveV3Ethereum.POOL);

    UpdateAAavePayload payload = new UpdateAAavePayload(address(aAaveToken));

    GovHelpers.executePayload(vm, address(payload), AaveGovernanceV2.SHORT_EXECUTOR);

    address newImpl = ProxyHelpers.getInitializableAdminUpgradeabilityProxyImplementation(
      vm,
      AaveV3EthereumAssets.AAVE_A_TOKEN
    );

    assertEq(newImpl, address(aAaveToken));
  }
}
