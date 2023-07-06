// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ATokenWithDelegation} from '../src/contracts/ATokenWithDelegation.sol';
import {IPool} from 'aave-v3-core/contracts/interfaces/IPool.sol';

abstract contract AAaveTokenScript {
  function _deploy(IPool pool) internal returns (address) {
    ATokenWithDelegation aAaveToken = new ATokenWithDelegation(pool);

    aAaveToken.initialize();

    return address(aAaveToken);
  }
}
