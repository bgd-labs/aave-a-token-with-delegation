// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IPool} from 'aave-v3-core/contracts/interfaces/IPool.sol';
import {BaseDelegation} from 'aave-token-v3/BaseDelegation.sol';
import {AToken} from 'aave-v3-core/contracts/protocol/tokenization/AToken.sol';

/**
 * @author BGD Labs
 * @notice contract that gives a tokens the delegation functionality. For now should only be used for AAVE aToken
 * @dev uint sizes are used taken into account that is tailored for AAVE token. In this AToken child we only update
        delegation balances. Balances amount is taken care of by AToken contract
 */
contract ATokenWithDelegation is AToken, BaseDelegation {
  mapping(address => DelegationBalance) internal _delegatedBalances;

  constructor(IPool pool) AToken(pool) {}

  function _getDomainSeparator() internal view override returns (bytes32) {
    return DOMAIN_SEPARATOR();
  }

  function _getDelegationBalance(
    address user
  ) internal view override returns (DelegationBalance memory) {
    return _delegatedBalances[user];
  }

  function _getBalance(address user) internal view override returns (uint256) {
    return _userState[user].balance;
  }

  function _incrementNonces(address user) internal override returns (uint256) {
    unchecked {
      // Does not make sense to check because it's not realistic to reach uint256.max in nonce
      return _nonces[user]++;
    }
  }

  function _setDelegationBalance(
    address user,
    DelegationBalance memory delegationBalance
  ) internal override {
    _delegatedBalances[user] = delegationBalance;
  }

  /**
   * @notice Overrides the parent _transfer to force validated transfer() and delegation balance transfers
   * @param from The source address
   * @param to The destination address
   * @param amount The amount getting transferred
   */
  function _transfer(address from, address to, uint128 amount) internal override {
    _delegationChangeOnTransfer(from, to, _getBalance(from), _getBalance(to), amount);
    _transfer(from, to, amount, true);
  }
}
