// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ConfiguratorInputTypes} from 'aave-address-book/AaveV3.sol';
import {AaveV3Ethereum, AaveV3EthereumAssets} from 'aave-address-book/AaveV3Ethereum.sol';

contract UpdateAAavePayload {
  address public immutable A_AAVE_IMPL;

  constructor(address aAaveImpl) {
    A_AAVE_IMPL = aAaveImpl;
  }

  function execute() external {
    // update aAave implementation
    ConfiguratorInputTypes.UpdateATokenInput memory input = ConfiguratorInputTypes
      .UpdateATokenInput({
        asset: AaveV3EthereumAssets.AAVE_UNDERLYING,
        treasury: address(AaveV3Ethereum.COLLECTOR),
        incentivesController: AaveV3Ethereum.DEFAULT_INCENTIVES_CONTROLLER,
        name: 'Aave Ethereum AAVE',
        symbol: 'aEthAAVE',
        implementation: A_AAVE_IMPL,
        params: '0x10' // this parameter is not actually used anywhere
      });

    AaveV3Ethereum.POOL_CONFIGURATOR.updateAToken(input);
  }
}
