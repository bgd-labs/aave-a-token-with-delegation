// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.10;

import {ECDSA} from 'openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol';
import {EIP712} from './EIP712.sol';

/**
 * @title EIP712Base
 * @author Aave
 * @notice Base contract implementation of EIP712.
 */
abstract contract EIP712Base is EIP712 {
  bytes public constant EIP712_REVISION = bytes('1');
  bytes32 internal constant EIP712_DOMAIN =
    keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)');

  // Map of address nonces (address => nonce)
  mapping(address => uint256) internal _nonces;

  bytes32 internal _domainSeparator;
  uint256 internal immutable _chainId;

  /**
   * @dev Constructor.
   */
  constructor() EIP712('Aave Ethereum AAVE', '1') {
    // TODO: what should the revision be??
    _chainId = block.chainid;
  }

  /**
   * @notice Get the domain separator for the token
   * @dev Return cached value if chainId matches cache, otherwise recomputes separator
   * @return The domain separator of the token at current chain
   */
  function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
    return _domainSeparatorV4();
  }

  /**
   * @notice Returns the nonce value for address specified as parameter
   * @param owner The address for which the nonce is being returned
   * @return The nonce value for the input address`
   */
  function nonces(address owner) public view virtual returns (uint256) {
    return _nonces[owner];
  }

  /**
   * @notice Returns the user readable name of signing domain (e.g. token name)
   * @return The name of the signing domain
   */
  function _EIP712BaseId() internal view virtual returns (string memory);
}
