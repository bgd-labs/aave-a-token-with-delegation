// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/Test.sol';
import {IPool, ATokenWithDelegation, IATokenWithDelegation, IGovernancePowerDelegationToken} from '../src/contracts/ATokenWithDelegation.sol';

contract ATokenWithDelegationTest is Test, ATokenWithDelegation {
  IPool constant pool = IPool(address(123));

  constructor() ATokenWithDelegation(pool) {}

  function setUp() public {
    console.log('test');
  }

  function testSomething() public {}
}
