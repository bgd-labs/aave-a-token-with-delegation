// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ATokenWithDelegation} from '../src/contracts/ATokenWithDelegation.sol';
import {IPool} from 'aave-v3-core/contracts/interfaces/IPool.sol';
import {IAaveIncentivesController} from 'aave-v3-factory/src/core/contracts/interfaces/IAaveIncentivesController.sol';

abstract contract AAaveTokenScript {
  function _deploy(
    IPool pool,
    address asset,
    address collector,
    address incentivesController
  ) internal returns (address) {
    ATokenWithDelegation aAaveToken = new ATokenWithDelegation(pool);

    aAaveToken.initialize(
      pool,
      asset,
      collector,
      IAaveIncentivesController(incentivesController),
      18,
      'Aave Ethereum AAVE',
      'aEthAAVE',
      '0x10'
    );

    return address(aAaveToken);
  }
}
