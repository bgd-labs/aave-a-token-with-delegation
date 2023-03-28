// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AToken} from './AToken.sol';
import {IPool} from 'aave-v3-core/interfaces/IPool.sol';
import {BaseDelegation} from 'aave-token-v3/BaseDelegation.sol';

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
    DelegationBalance storage userState = _delegatedBalances[user];
    userState.delegatedPropositionBalance = delegationBalance.delegatedPropositionBalance;
    userState.delegatedVotingBalance = delegationBalance.delegatedVotingBalance;
    userState.delegationState = delegationBalance.delegationState;
  }

  function _afterTokenTransfer(address from, address to, uint256 amount) internal override {
    uint256 fromBalanceBefore = _getBalance(from);
    uint256 toBalanceBefore = _getBalance(to);
    _delegationChangeOnTransfer(from, to, fromBalanceBefore, toBalanceBefore, amount);
  }
}
