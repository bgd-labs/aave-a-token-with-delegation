```diff
diff --git a/lib/openzeppelin-contracts/contracts/utils/cryptography/EIP712.sol b/src/contracts/dependencies/EIP712.sol
index 5a2bd84..91f4989 100644
--- a/lib/openzeppelin-contracts/contracts/utils/cryptography/EIP712.sol
+++ b/src/contracts/dependencies/EIP712.sol
@@ -3,9 +3,9 @@
 
 pragma solidity ^0.8.10;
 
-import "./ECDSA.sol";
-import "../ShortStrings.sol";
-import "../../interfaces/IERC5267.sol";
+import {ECDSA} from 'openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol';
+import {ShortStrings, ShortString} from 'openzeppelin-contracts/contracts/utils/ShortStrings.sol';
+import {IERC5267} from 'openzeppelin-contracts/contracts/interfaces/IERC5267.sol';
 
 /**
  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
@@ -33,135 +33,137 @@ import "../../interfaces/IERC5267.sol";
  * @custom:oz-upgrades-unsafe-allow state-variable-immutable state-variable-assignment
  */
 abstract contract EIP712 is IERC5267 {
-    using ShortStrings for *;
+  using ShortStrings for *;
 
-    bytes32 private constant _TYPE_HASH =
-        keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
+  bytes32 private constant _TYPE_HASH =
+    keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)');
 
-    // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
-    // invalidate the cached domain separator if the chain id changes.
-    bytes32 private immutable _cachedDomainSeparator;
-    uint256 private immutable _cachedChainId;
-    address private immutable _cachedThis;
+  // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
+  // invalidate the cached domain separator if the chain id changes.
+  bytes32 private immutable _cachedDomainSeparator;
+  uint256 private immutable _cachedChainId;
+  address private immutable _cachedThis;
 
-    bytes32 private immutable _hashedName;
-    bytes32 private immutable _hashedVersion;
+  bytes32 private immutable _hashedName;
+  bytes32 private immutable _hashedVersion;
 
-    ShortString private immutable _name;
-    ShortString private immutable _version;
-    string private _nameFallback;
-    string private _versionFallback;
+  ShortString private immutable _name;
+  ShortString private immutable _version;
 
-    /**
-     * @dev Initializes the domain separator and parameter caches.
-     *
-     * The meaning of `name` and `version` is specified in
-     * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
-     *
-     * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
-     * - `version`: the current major version of the signing domain.
-     *
-     * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
-     * contract upgrade].
-     */
-    constructor(string memory name, string memory version) {
-        _name = name.toShortStringWithFallback(_nameFallback);
-        _version = version.toShortStringWithFallback(_versionFallback);
-        _hashedName = keccak256(bytes(name));
-        _hashedVersion = keccak256(bytes(version));
+  //  string private constant _nameFallback;
+  //  string private _versionFallback;
 
-        _cachedChainId = block.chainid;
-        _cachedDomainSeparator = _buildDomainSeparator();
-        _cachedThis = address(this);
-    }
+  /**
+   * @dev Initializes the domain separator and parameter caches.
+   *
+   * The meaning of `name` and `version` is specified in
+   * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
+   *
+   * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
+   * - `version`: the current major version of the signing domain.
+   *
+   * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
+   * contract upgrade].
+   */
+  constructor(string memory name, string memory version) {
+    _name = name.toShortString(); //name.toShortStringWithFallback(_nameFallback);
+    _version = version.toShortString(); //version.toShortStringWithFallback(_versionFallback);
+    _hashedName = keccak256(bytes(name));
+    _hashedVersion = keccak256(bytes(version));
 
-    /**
-     * @dev Returns the domain separator for the current chain.
-     */
-    function _domainSeparatorV4() internal view returns (bytes32) {
-        if (address(this) == _cachedThis && block.chainid == _cachedChainId) {
-            return _cachedDomainSeparator;
-        } else {
-            return _buildDomainSeparator();
-        }
-    }
+    _cachedChainId = block.chainid;
+    _cachedDomainSeparator = _buildDomainSeparator();
+    _cachedThis = address(this);
+  }
 
-    function _buildDomainSeparator() private view returns (bytes32) {
-        return keccak256(abi.encode(_TYPE_HASH, _hashedName, _hashedVersion, block.chainid, address(this)));
+  /**
+   * @dev Returns the domain separator for the current chain.
+   */
+  function _domainSeparatorV4() internal view returns (bytes32) {
+    if (address(this) == _cachedThis && block.chainid == _cachedChainId) {
+      return _cachedDomainSeparator;
+    } else {
+      return _buildDomainSeparator();
     }
+  }
 
-    /**
-     * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
-     * function returns the hash of the fully encoded EIP712 message for this domain.
-     *
-     * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
-     *
-     * ```solidity
-     * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
-     *     keccak256("Mail(address to,string contents)"),
-     *     mailTo,
-     *     keccak256(bytes(mailContents))
-     * )));
-     * address signer = ECDSA.recover(digest, signature);
-     * ```
-     */
-    function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
-        return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
-    }
+  function _buildDomainSeparator() private view returns (bytes32) {
+    return
+      keccak256(abi.encode(_TYPE_HASH, _hashedName, _hashedVersion, block.chainid, address(this)));
+  }
 
-    /**
-     * @dev See {EIP-5267}.
-     *
-     * _Available since v4.9._
-     */
-    function eip712Domain()
-        public
-        view
-        virtual
-        returns (
-            bytes1 fields,
-            string memory name,
-            string memory version,
-            uint256 chainId,
-            address verifyingContract,
-            bytes32 salt,
-            uint256[] memory extensions
-        )
-    {
-        return (
-            hex"0f", // 01111
-            _EIP712Name(),
-            _EIP712Version(),
-            block.chainid,
-            address(this),
-            bytes32(0),
-            new uint256[](0)
-        );
-    }
+  /**
+   * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
+   * function returns the hash of the fully encoded EIP712 message for this domain.
+   *
+   * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
+   *
+   * ```solidity
+   * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
+   *     keccak256("Mail(address to,string contents)"),
+   *     mailTo,
+   *     keccak256(bytes(mailContents))
+   * )));
+   * address signer = ECDSA.recover(digest, signature);
+   * ```
+   */
+  function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
+    return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
+  }
 
-    /**
-     * @dev The name parameter for the EIP712 domain.
-     *
-     * NOTE: By default this function reads _name which is an immutable value.
-     * It only reads from storage if necessary (in case the value is too large to fit in a ShortString).
-     *
-     * _Available since v5.0._
-     */
-    // solhint-disable-next-line func-name-mixedcase
-    function _EIP712Name() internal view returns (string memory) {
-        return _name.toStringWithFallback(_nameFallback);
-    }
+  /**
+   * @dev See {EIP-5267}.
+   *
+   * _Available since v4.9._
+   */
+  function eip712Domain()
+    public
+    view
+    virtual
+    returns (
+      bytes1 fields,
+      string memory name,
+      string memory version,
+      uint256 chainId,
+      address verifyingContract,
+      bytes32 salt,
+      uint256[] memory extensions
+    )
+  {
+    return (
+      hex'0f', // 01111
+      _EIP712Name(),
+      _EIP712Version(),
+      block.chainid,
+      address(this),
+      bytes32(0),
+      new uint256[](0)
+    );
+  }
 
-    /**
-     * @dev The version parameter for the EIP712 domain.
-     *
-     * NOTE: By default this function reads _version which is an immutable value.
-     * It only reads from storage if necessary (in case the value is too large to fit in a ShortString).
-     *
-     * _Available since v5.0._
-     */
-    // solhint-disable-next-line func-name-mixedcase
-    function _EIP712Version() internal view returns (string memory) {
-        return _version.toStringWithFallback(_versionFallback);
-    }
+  /**
+   * @dev The name parameter for the EIP712 domain.
+   *
+   * NOTE: By default this function reads _name which is an immutable value.
+   * It only reads from storage if necessary (in case the value is too large to fit in a ShortString).
+   *
+   * _Available since v5.0._
+   */
+  // solhint-disable-next-line func-name-mixedcase
+  function _EIP712Name() internal view returns (string memory) {
+    return _name.toString(); // _name.toStringWithFallback(_nameFallback);
+  }
+
+  /**
+   * @dev The version parameter for the EIP712 domain.
+   *
+   * NOTE: By default this function reads _version which is an immutable value.
+   * It only reads from storage if necessary (in case the value is too large to fit in a ShortString).
+   *
+   * _Available since v5.0._
+   */
+  // solhint-disable-next-line func-name-mixedcase
+  function _EIP712Version() internal view returns (string memory) {
+    return _version.toString(); // _version.toStringWithFallback(_versionFallback);
+  }
 }
```
