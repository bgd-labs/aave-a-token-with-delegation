```diff
diff --git a/./etherscan/AToken/@aave/core-v3/contracts/protocol/tokenization/AToken.sol b/./src/contracts/AToken.sol
index 57f3b16..e5a70e5 100644
--- a/./etherscan/AToken/@aave/core-v3/contracts/protocol/tokenization/AToken.sol
+++ b/./src/contracts/AToken.sol
@@ -1,19 +1,19 @@
 // SPDX-License-Identifier: BUSL-1.1
 pragma solidity 0.8.10;
 
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
+import {VersionedInitializable} from 'aave-v3-core/contracts/protocol/libraries/aave-upgradeability/VersionedInitializable.sol';
+import {Errors} from 'aave-v3-core/contracts/protocol/libraries/helpers/Errors.sol';
+import {WadRayMath} from 'aave-v3-core/contracts/protocol/libraries/math/WadRayMath.sol';
+import {ScaledBalanceTokenBase} from 'aave-v3-core/contracts/protocol/tokenization/base/ScaledBalanceTokenBase.sol';
+import {EIP712Base} from 'aave-v3-core/contracts/protocol/tokenization/base/EIP712Base.sol';
+import {IncentivizedERC20} from 'aave-v3-core/contracts/protocol/tokenization/base/IncentivizedERC20.sol';
+import {IAToken} from 'aave-v3-core/contracts/interfaces/IAToken.sol';
+import {IPool} from 'aave-v3-core/contracts/interfaces/IPool.sol';
+import {IAaveIncentivesController} from 'aave-v3-core/contracts/interfaces/IAaveIncentivesController.sol';
+import {IInitializableAToken} from 'aave-v3-core/contracts/interfaces/IInitializableAToken.sol';
+import {GPv2SafeERC20} from 'aave-v3-core/contracts/dependencies/gnosis/contracts/GPv2SafeERC20.sol';
+import {IERC20} from 'aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20.sol';
+import {SafeCast} from 'aave-v3-core/contracts/dependencies/openzeppelin/contracts/SafeCast.sol';
 
 /**
  * @title Aave ERC20 AToken
@@ -224,6 +224,9 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
    * @param amount The amount getting transferred
    */
   function _transfer(address from, address to, uint128 amount) internal virtual override {
+    // transfer delegation balances
+    _beforeTokenTransfer(from, to, amount);
+
     _transfer(from, to, amount, true);
   }
 
@@ -253,4 +256,12 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
     require(token != _underlyingAsset, Errors.UNDERLYING_CANNOT_BE_RESCUED);
     IERC20(token).safeTransfer(to, amount);
   }
+
+  /**
+   * @dev before token transfer hook, added for delegation system
+   * @param from token sender
+   * @param to token recipient
+   * @param amount amount of tokens sent
+   **/
+  function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
 }
```
