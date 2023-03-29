```diff
diff --git a/./etherscan/AToken/@aave/core-v3/contracts/protocol/tokenization/AToken.sol b/./src/contracts/AToken.sol
index 4abfb1d..d84245c 100644
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
@@ -42,10 +42,9 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
    * @dev Constructor.
    * @param pool The address of the Pool contract
    */
-  constructor(IPool pool)
-    ScaledBalanceTokenBase(pool, 'ATOKEN_IMPL', 'ATOKEN_IMPL', 0)
-    EIP712Base()
-  {
+  constructor(
+    IPool pool
+  ) ScaledBalanceTokenBase(pool, 'ATOKEN_IMPL', 'ATOKEN_IMPL', 0) EIP712Base() {
     // Intentionally left blank
   }
 
@@ -126,13 +125,9 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
   }
 
   /// @inheritdoc IERC20
-  function balanceOf(address user)
-    public
-    view
-    virtual
-    override(IncentivizedERC20, IERC20)
-    returns (uint256)
-  {
+  function balanceOf(
+    address user
+  ) public view virtual override(IncentivizedERC20, IERC20) returns (uint256) {
     return super.balanceOf(user).rayMul(POOL.getReserveNormalizedIncome(_underlyingAsset));
   }
 
@@ -205,12 +200,7 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
    * @param amount The amount getting transferred
    * @param validate True if the transfer needs to be validated, false otherwise
    */
-  function _transfer(
-    address from,
-    address to,
-    uint256 amount,
-    bool validate
-  ) internal virtual {
+  function _transfer(address from, address to, uint256 amount, bool validate) internal virtual {
     address underlyingAsset = _underlyingAsset;
 
     uint256 index = POOL.getReserveNormalizedIncome(underlyingAsset);
@@ -233,11 +223,10 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
    * @param to The destination address
    * @param amount The amount getting transferred
    */
-  function _transfer(
-    address from,
-    address to,
-    uint128 amount
-  ) internal virtual override {
+  function _transfer(address from, address to, uint128 amount) internal virtual override {
+    // transfer delegation balances
+    _afterTokenTransfer(from, to, amount);
+
     _transfer(from, to, amount, true);
   }
 
@@ -263,12 +252,16 @@ contract AToken is VersionedInitializable, ScaledBalanceTokenBase, EIP712Base, I
   }
 
   /// @inheritdoc IAToken
-  function rescueTokens(
-    address token,
-    address to,
-    uint256 amount
-  ) external override onlyPoolAdmin {
+  function rescueTokens(address token, address to, uint256 amount) external override onlyPoolAdmin {
     require(token != _underlyingAsset, Errors.UNDERLYING_CANNOT_BE_RESCUED);
     IERC20(token).safeTransfer(to, amount);
   }
+
+  /**
+   * @dev after token transfer hook, added for delegation system
+   * @param from token sender
+   * @param to token recipient
+   * @param amount amount of tokens sent
+   **/
+  function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
 }
```
