// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {IPool, ATokenWithDelegation, IATokenWithDelegation, IGovernancePowerDelegationToken} from '../src/contracts/ATokenWithDelegation.sol';

contract PoolMock {
  address public constant ADDRESSES_PROVIDER = address(12351);
}

contract ATokenWithDelegationTest is Test, ATokenWithDelegation {
  function setUp() public {}

  constructor() ATokenWithDelegation(IPool(address(new PoolMock()))) {}

  function testSomething() public {}
}
