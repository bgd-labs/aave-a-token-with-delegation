// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EthereumScript} from 'aave-helpers/ScriptUtils.sol';
import {UpdateAAavePayload} from '../src/contracts/payload/UpdateAAavePayload.sol';

contract DeployUpdateAAavePayload is EthereumScript {
  address public constant A_AAVE_IMPL = address(1);

  // TODO: this should be get from address-book
  function run() external broadcast {
    new UpdateAAavePayload(A_AAVE_IMPL);
  }
}
