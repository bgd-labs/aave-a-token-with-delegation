```diff
diff --git a/lib/aave-v3-factory/src/core/contracts/interfaces/IInitializableAToken.sol b/src/contracts/interfaces/IInitializableAToken.sol
index 0b16baa..8beab5f 100644
--- a/lib/aave-v3-factory/src/core/contracts/interfaces/IInitializableAToken.sol
+++ b/src/contracts/interfaces/IInitializableAToken.sol
@@ -1,8 +1,8 @@
 // SPDX-License-Identifier: AGPL-3.0
 pragma solidity ^0.8.0;
 
-import {IAaveIncentivesController} from './IAaveIncentivesController.sol';
-import {IPool} from './IPool.sol';
+import {IAaveIncentivesController} from 'aave-v3-factory/core/contracts/interfaces/IAaveIncentivesController.sol';
+import {IPool} from 'aave-v3-factory/core/contracts/interfaces/IPool.sol';
 
 /**
  * @title IInitializableAToken
@@ -34,23 +34,7 @@ interface IInitializableAToken {
 
   /**
    * @notice Initializes the aToken
-   * @param pool The pool contract that is initializing this contract
-   * @param treasury The address of the Aave treasury, receiving the fees on this aToken
-   * @param underlyingAsset The address of the underlying asset of this aToken (E.g. WETH for aWETH)
-   * @param incentivesController The smart contract managing potential incentives distribution
-   * @param aTokenDecimals The decimals of the aToken, same as the underlying asset's
-   * @param aTokenName The name of the aToken
-   * @param aTokenSymbol The symbol of the aToken
-   * @param params A set of encoded parameters for additional initialization
+   * @dev There are no params as its the second initialization, so all variables are already set.
    */
-  function initialize(
-    IPool pool,
-    address treasury,
-    address underlyingAsset,
-    IAaveIncentivesController incentivesController,
-    uint8 aTokenDecimals,
-    string calldata aTokenName,
-    string calldata aTokenSymbol,
-    bytes calldata params
-  ) external;
+  function initialize() external;
 }
```
