```diff
diff --git a/lib/aave-v3-factory/src/core/contracts/protocol/tokenization/AToken.sol b/src/contracts/AToken.sol
index f613b66..4ec85a2 100644
--- a/lib/aave-v3-factory/src/core/contracts/protocol/tokenization/AToken.sol
+++ b/src/contracts/AToken.sol
@@ -1,19 +1,20 @@
-// SPDX-License-Identifier: BUSL-1.1
+// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.10;
 
-import {IERC20} from '../../dependencies/openzeppelin/contracts/IERC20.sol';
-import {GPv2SafeERC20} from '../../dependencies/gnosis/contracts/GPv2SafeERC20.sol';
-import {SafeCast} from '../../dependencies/openzeppelin/contracts/SafeCast.sol';
-import {VersionedInitializable} from '../libraries/aave-upgradeability/VersionedInitializable.sol';
-import {Errors} from '../libraries/helpers/Errors.sol';
-import {WadRayMath} from '../libraries/math/WadRayMath.sol';
-import {IPool} from '../../interfaces/IPool.sol';
-import {IAToken} from '../../interfaces/IAToken.sol';
-import {IAaveIncentivesController} from '../../interfaces/IAaveIncentivesController.sol';
-import {IInitializableAToken} from '../../interfaces/IInitializableAToken.sol';
-import {ScaledBalanceTokenBase} from './base/ScaledBalanceTokenBase.sol';
-import {IncentivizedERC20} from './base/IncentivizedERC20.sol';
-import {EIP712Base} from './base/EIP712Base.sol';
+import {IERC20} from 'aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20.sol';
+import {GPv2SafeERC20} from 'aave-v3-core/contracts/dependencies/gnosis/contracts/GPv2SafeERC20.sol';
+import {SafeCast} from './dependencies/SafeCast.sol';
+import {VersionedInitializable} from 'aave-v3-core/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol';
+import {Errors} from 'aave-v3-core/contracts/protocol/libraries/helpers/Errors.sol';
+import {WadRayMath} from 'aave-v3-core/contracts/protocol/libraries/math/WadRayMath.sol';
+import {IPool} from 'aave-v3-core/contracts/interfaces/IPool.sol';
+import {IAToken} from 'aave-v3-core/contracts/interfaces/IAToken.sol';
+import {IAaveIncentivesController} from 'aave-v3-core/contracts/interfaces/IAaveIncentivesController.sol';
+import {IInitializableAToken} from 'aave-v3-core/contracts/interfaces/IInitializableAToken.sol';
+import {ScaledBalanceTokenBase} from './ScaledBalanceTokenBase.sol';
+import {IncentivizedERC20} from './IncentivizedERC20.sol';
+import {EIP712Base} from './dependencies/EIP712Base.sol';
+import {ECDSA} from 'openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol';
 
 /**
  * @title Aave ERC20 AToken
@@ -28,7 +29,7 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
   bytes32 public constant PERMIT_TYPEHASH =
     keccak256('Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)');
 
-  uint256 public constant ATOKEN_REVISION = 0x1;
+  uint256 public constant ATOKEN_REVISION = 0x2;
 
   address internal _treasury;
   address internal _underlyingAsset;
@@ -67,9 +68,7 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
     _treasury = treasury;
     _underlyingAsset = underlyingAsset;
     _incentivesController = incentivesController;
-
-    _domainSeparator = _calculateDomainSeparator();
-
+    _domainSeparator = _domainSeparatorV4(); // TODO: not sure if needed
     emit Initialized(
       underlyingAsset,
       address(POOL),
@@ -180,14 +179,10 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
     //solium-disable-next-line
     require(block.timestamp <= deadline, Errors.INVALID_EXPIRATION);
     uint256 currentValidNonce = _nonces[owner];
-    bytes32 digest = keccak256(
-      abi.encodePacked(
-        '\x19\x01',
-        DOMAIN_SEPARATOR(),
-        keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, currentValidNonce, deadline))
-      )
+    bytes32 digest = _hashTypedDataV4(
+      keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, currentValidNonce, deadline))
     );
-    require(owner == ecrecover(digest, v, r, s), Errors.INVALID_SIGNATURE);
+    require(owner == ECDSA.recover(digest, v, r, s), Errors.INVALID_SIGNATURE);
     _nonces[owner] = currentValidNonce + 1;
     _approve(owner, spender, value);
   }
@@ -223,7 +218,7 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
    * @param to The destination address
    * @param amount The amount getting transferred
    */
-  function _transfer(address from, address to, uint128 amount) internal virtual override {
+  function _transfer(address from, address to, uint120 amount) internal virtual override {
     _transfer(from, to, amount, true);
   }
 
```
