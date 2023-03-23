// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IGovernancePowerDelegationToken} from '../interfaces/IGovernancePowerDelegationToken.sol';
import {AToken} from 'aave-v3-core/protocol/tokenization/AToken.sol';
import {IPool} from 'aave-v3-core/interfaces/IPool.sol';
import {IATokenWithDelegation} from '../interfaces/IATokenWithDelegation.sol';

/**
 * @author BGD Labs
 * @notice contract that gives a tokens the delegation functionality. For now should only be used for AAVE aToken
 * @dev uint sizes are used taken into account that is tailored for AAVE token. In this AToken child we only update
        delegation balances. Balances amount is taken care of by AToken contract
 */
contract ATokenWithDelegation is AToken, IGovernancePowerDelegationToken, IATokenWithDelegation {
  mapping(address => address) internal _votingDelegateeV2;
  mapping(address => address) internal _propositionDelegateeV2;

  mapping(address => DelegationAwareBalance) internal _delegatedBalances;

  /// @dev we assume that for the governance system 18 decimals of precision is not needed,
  // by this constant we reduce it by 10, to 8 decimals
  uint256 public constant POWER_SCALE_FACTOR = 1e10;

  bytes32 public constant DELEGATE_BY_TYPE_TYPEHASH =
    keccak256(
      'DelegateByType(address delegator,address delegatee,GovernancePowerType delegationType,uint256 nonce,uint256 deadline)'
    );
  bytes32 public constant DELEGATE_TYPEHASH =
    keccak256('Delegate(address delegator,address delegatee,uint256 nonce,uint256 deadline)');

  bytes32 public DELEGATE_DOMAIN_SEPARATOR;

  constructor(IPool pool) AToken(pool) {
    uint256 chainId;
    assembly {
      chainId := chainid()
    }

    DELEGATE_DOMAIN_SEPARATOR = keccak256(
      abi.encode(
        EIP712_DOMAIN,
        keccak256(bytes(name())),
        keccak256(EIP712_REVISION),
        chainId,
        address(this)
      )
    );
  }

  /// @inheritdoc IGovernancePowerDelegationToken
  function delegateByType(
    address delegatee,
    GovernancePowerType delegationType
  ) external virtual override {
    _delegateByType(msg.sender, delegatee, delegationType);
  }

  /// @inheritdoc IGovernancePowerDelegationToken
  function delegate(address delegatee) external override {
    _delegateByType(msg.sender, delegatee, GovernancePowerType.VOTING);
    _delegateByType(msg.sender, delegatee, GovernancePowerType.PROPOSITION);
  }

  /// @inheritdoc IGovernancePowerDelegationToken
  function getDelegateeByType(
    address delegator,
    GovernancePowerType delegationType
  ) external view override returns (address) {
    return _getDelegateeByType(delegator, _delegatedBalances[delegator], delegationType);
  }

  /// @inheritdoc IGovernancePowerDelegationToken
  function getDelegates(address delegator) external view override returns (address, address) {
    DelegationAwareBalance memory delegatorDelegatedBalance = _delegatedBalances[delegator];
    return (
      _getDelegateeByType(delegator, delegatorDelegatedBalance, GovernancePowerType.VOTING),
      _getDelegateeByType(delegator, delegatorDelegatedBalance, GovernancePowerType.PROPOSITION)
    );
  }

  /// @inheritdoc IGovernancePowerDelegationToken
  function getPowerCurrent(
    address user,
    GovernancePowerType delegationType
  ) public view override returns (uint256) {
    DelegationAwareBalance memory userDelegatedState = _delegatedBalances[user];
    uint256 userOwnPower = uint8(userDelegatedState.delegationState) &
      (uint8(delegationType) + 1) ==
      0
      ? _userState[user].balance
      : 0;
    uint256 userDelegatedPower = _getDelegatedPowerByType(userDelegatedState, delegationType);
    return userOwnPower + userDelegatedPower;
  }

  /// @inheritdoc IGovernancePowerDelegationToken
  function getPowersCurrent(address user) external view override returns (uint256, uint256) {
    return (
      getPowerCurrent(user, GovernancePowerType.VOTING),
      getPowerCurrent(user, GovernancePowerType.PROPOSITION)
    );
  }

  /// @inheritdoc IGovernancePowerDelegationToken
  function metaDelegateByType(
    address delegator,
    address delegatee,
    GovernancePowerType delegationType,
    uint256 deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external override {
    require(delegator != address(0), 'INVALID_OWNER');
    //solium-disable-next-line
    require(block.timestamp <= deadline, 'INVALID_EXPIRATION');
    uint256 currentValidNonce = _nonces[delegator];
    bytes32 digest = keccak256(
      abi.encodePacked(
        '\x19\x01',
        DELEGATE_DOMAIN_SEPARATOR,
        keccak256(
          abi.encode(
            DELEGATE_BY_TYPE_TYPEHASH,
            delegator,
            delegatee,
            delegationType,
            currentValidNonce,
            deadline
          )
        )
      )
    );

    require(delegator == ecrecover(digest, v, r, s), 'INVALID_SIGNATURE');
    unchecked {
      // Does not make sense to check because it's not realistic to reach uint256.max in nonce
      _nonces[delegator] = currentValidNonce + 1;
    }
    _delegateByType(delegator, delegatee, delegationType);
  }

  /// @inheritdoc IGovernancePowerDelegationToken
  function metaDelegate(
    address delegator,
    address delegatee,
    uint256 deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external override {
    require(delegator != address(0), 'INVALID_OWNER');
    //solium-disable-next-line
    require(block.timestamp <= deadline, 'INVALID_EXPIRATION');
    uint256 currentValidNonce = _nonces[delegator];
    bytes32 digest = keccak256(
      abi.encodePacked(
        '\x19\x01',
        DELEGATE_DOMAIN_SEPARATOR,
        keccak256(abi.encode(DELEGATE_TYPEHASH, delegator, delegatee, currentValidNonce, deadline))
      )
    );

    require(delegator == ecrecover(digest, v, r, s), 'INVALID_SIGNATURE');
    unchecked {
      // does not make sense to check because it's not realistic to reach uint256.max in nonce
      _nonces[delegator] = currentValidNonce + 1;
    }
    _delegateByType(delegator, delegatee, GovernancePowerType.VOTING);
    _delegateByType(delegator, delegatee, GovernancePowerType.PROPOSITION);
  }

  /**
   * @dev Modifies the delegated power of a `delegatee` account by type (VOTING, PROPOSITION).
   * Passing the impact on the delegation of `delegatee` account before and after to reduce conditionals and not lose
   * any precision.
   * @param impactOnDelegationBefore how much impact a balance of another account had over the delegation of a `delegatee`
   * before an action.
   * For example, if the action is a delegation from one account to another, the impact before the action will be 0.
   * @param impactOnDelegationAfter how much impact a balance of another account will have  over the delegation of a `delegatee`
   * after an action.
   * For example, if the action is a delegation from one account to another, the impact after the action will be the whole balance
   * of the account changing the delegatee.
   * @param delegatee the user whom delegated governance power will be changed
   * @param delegationType the type of governance power delegation (VOTING, PROPOSITION)
   **/
  function _governancePowerTransferByType(
    uint104 impactOnDelegationBefore,
    uint104 impactOnDelegationAfter,
    address delegatee,
    GovernancePowerType delegationType
  ) internal {
    if (delegatee == address(0)) return;
    if (impactOnDelegationBefore == impactOnDelegationAfter) return;

    // To make delegated balance fit into uint72 we're decreasing precision of delegated balance by POWER_SCALE_FACTOR
    uint72 impactOnDelegationBefore72 = uint72(impactOnDelegationBefore / POWER_SCALE_FACTOR);
    uint72 impactOnDelegationAfter72 = uint72(impactOnDelegationAfter / POWER_SCALE_FACTOR);

    if (delegationType == GovernancePowerType.VOTING) {
      _delegatedBalances[delegatee].delegatedVotingBalance =
        _delegatedBalances[delegatee].delegatedVotingBalance -
        impactOnDelegationBefore72 +
        impactOnDelegationAfter72;
    } else {
      _delegatedBalances[delegatee].delegatedPropositionBalance =
        _delegatedBalances[delegatee].delegatedPropositionBalance -
        impactOnDelegationBefore72 +
        impactOnDelegationAfter72;
    }
  }

  /**
   * @dev performs all state changes related to balance transfer and corresponding delegation changes
   * @param from token sender
   * @param to token recipient
   * @param amount amount of tokens sent
   **/
  function _transferWithDelegation(address from, address to, uint256 amount) internal override {
    if (from == to) {
      return;
    }

    if (from != address(0)) {
      DelegationAwareBalance memory fromUserDelegatedState = _delegatedBalances[from];
      uint104 fromUserBalance = uint104(_userState[from].balance);
      require(fromUserBalance >= amount, 'ERC20: transfer amount exceeds balance');

      uint104 fromBalanceAfter;
      unchecked {
        fromBalanceAfter = fromUserBalance - uint104(amount);
      }

      if (fromUserDelegatedState.delegationState != DelegationState.NO_DELEGATION) {
        _governancePowerTransferByType(
          fromUserBalance,
          fromBalanceAfter,
          _getDelegateeByType(from, fromUserDelegatedState, GovernancePowerType.VOTING),
          GovernancePowerType.VOTING
        );
        _governancePowerTransferByType(
          fromUserBalance,
          fromBalanceAfter,
          _getDelegateeByType(from, fromUserDelegatedState, GovernancePowerType.PROPOSITION),
          GovernancePowerType.PROPOSITION
        );
      }
    }

    if (to != address(0)) {
      DelegationAwareBalance memory toUserDelegatedState = _delegatedBalances[to];
      uint104 toUserBalance = uint104(_userState[to].balance);
      uint104 toBalanceAfter = toUserBalance + uint104(amount);

      if (toUserDelegatedState.delegationState != DelegationState.NO_DELEGATION) {
        _governancePowerTransferByType(
          toUserBalance,
          toBalanceAfter,
          _getDelegateeByType(to, toUserDelegatedState, GovernancePowerType.VOTING),
          GovernancePowerType.VOTING
        );
        _governancePowerTransferByType(
          toUserBalance,
          toBalanceAfter,
          _getDelegateeByType(to, toUserDelegatedState, GovernancePowerType.PROPOSITION),
          GovernancePowerType.PROPOSITION
        );
      }
    }
  }

  /**
   * @dev Extracts from state and returns delegated governance power (Voting, Proposition)
   * @param userDelegatedState the current state of a user
   * @param delegationType the type of governance power delegation (VOTING, PROPOSITION)
   **/
  function _getDelegatedPowerByType(
    DelegationAwareBalance memory userDelegatedState,
    GovernancePowerType delegationType
  ) internal pure returns (uint256) {
    return
      POWER_SCALE_FACTOR *
      (
        delegationType == GovernancePowerType.VOTING
          ? userDelegatedState.delegatedVotingBalance
          : userDelegatedState.delegatedPropositionBalance
      );
  }

  /**
   * @dev Extracts from state and returns the delegatee of a delegator by type of governance power (Voting, Proposition)
   * - If the delegator doesn't have any delegatee, returns address(0)
   * @param delegator delegator
   * @param userDelegationState the current state of a user
   * @param delegationType the type of governance power delegation (VOTING, PROPOSITION)
   **/
  function _getDelegateeByType(
    address delegator,
    DelegationAwareBalance memory userDelegationState,
    GovernancePowerType delegationType
  ) internal view returns (address) {
    if (delegationType == GovernancePowerType.VOTING) {
      return
        /// With the & operation, we cover both VOTING_DELEGATED delegation and FULL_POWER_DELEGATED
        /// as VOTING_DELEGATED is equivalent to 01 in binary and FULL_POWER_DELEGATED is equivalent to 11
        (uint8(userDelegationState.delegationState) & uint8(DelegationState.VOTING_DELEGATED)) != 0
          ? _votingDelegateeV2[delegator]
          : address(0);
    }
    return
      userDelegationState.delegationState >= DelegationState.PROPOSITION_DELEGATED
        ? _propositionDelegateeV2[delegator]
        : address(0);
  }

  /**
   * @dev Changes user's delegatee address by type of governance power (Voting, Proposition)
   * @param delegator delegator
   * @param delegationType the type of governance power delegation (VOTING, PROPOSITION)
   * @param _newDelegatee the new delegatee
   **/
  function _updateDelegateeByType(
    address delegator,
    GovernancePowerType delegationType,
    address _newDelegatee
  ) internal {
    address newDelegatee = _newDelegatee == delegator ? address(0) : _newDelegatee;
    if (delegationType == GovernancePowerType.VOTING) {
      _votingDelegateeV2[delegator] = newDelegatee;
    } else {
      _propositionDelegateeV2[delegator] = newDelegatee;
    }
  }

  /**
   * @dev Updates the specific flag which signaling about existence of delegation of governance power (Voting, Proposition)
   * @param userDelegatedState a user state to change
   * @param delegationType the type of governance power delegation (VOTING, PROPOSITION)
   * @param willDelegate next state of delegation
   **/
  function _updateDelegationFlagByType(
    DelegationAwareBalance memory userDelegatedState,
    GovernancePowerType delegationType,
    bool willDelegate
  ) internal pure returns (DelegationAwareBalance memory) {
    if (willDelegate) {
      // Because GovernancePowerType starts from 0, we should add 1 first, then we apply bitwise OR
      userDelegatedState.delegationState = DelegationState(
        uint8(userDelegatedState.delegationState) | (uint8(delegationType) + 1)
      );
    } else {
      // First bitwise NEGATION, ie was 01, after XOR with 11 will be 10,
      // then bitwise AND, which means it will keep only another delegation type if it exists
      userDelegatedState.delegationState = DelegationState(
        uint8(userDelegatedState.delegationState) &
          ((uint8(delegationType) + 1) ^ uint8(DelegationState.FULL_POWER_DELEGATED))
      );
    }
    return userDelegatedState;
  }

  /**
   * @dev This is the equivalent of an ERC20 transfer(), but for a power type: an atomic transfer of a balance (power).
   * When needed, it decreases the power of the `delegator` and when needed, it increases the power of the `delegatee`
   * @param delegator delegator
   * @param _delegatee the user which delegated power will change
   * @param delegationType the type of delegation (VOTING, PROPOSITION)
   **/
  function _delegateByType(
    address delegator,
    address _delegatee,
    GovernancePowerType delegationType
  ) internal {
    // Here we unify the property that delegating power to address(0) == delegating power to yourself == no delegation
    // So from now on, not being delegating is (exclusively) that delegatee == address(0)
    address delegatee = _delegatee == delegator ? address(0) : _delegatee;

    // We read the whole struct before validating delegatee, because in the optimistic case
    // (_delegatee != currentDelegatee) we will reuse userState in the rest of the function
    DelegationAwareBalance memory delegatorState = _delegatedBalances[delegator];
    address currentDelegatee = _getDelegateeByType(delegator, delegatorState, delegationType);
    if (delegatee == currentDelegatee) return;

    bool delegatingNow = currentDelegatee != address(0);
    bool willDelegateAfter = delegatee != address(0);

    if (delegatingNow) {
      _governancePowerTransferByType(
        uint104(_userState[delegator].balance),
        0,
        currentDelegatee,
        delegationType
      );
    }

    if (willDelegateAfter) {
      _governancePowerTransferByType(
        0,
        uint104(_userState[delegator].balance),
        delegatee,
        delegationType
      );
    }

    _updateDelegateeByType(delegator, delegationType, delegatee);

    if (willDelegateAfter != delegatingNow) {
      _delegatedBalances[delegator] = _updateDelegationFlagByType(
        delegatorState,
        delegationType,
        willDelegateAfter
      );
    }

    emit DelegateChanged(delegator, delegatee, delegationType);
  }
}
