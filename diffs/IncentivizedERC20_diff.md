```diff
diff --git a/lib/aave-v3-core/contracts/protocol/tokenization/base/IncentivizedERC20.sol b/src/contracts/IncentivizedERC20.sol
index 08a219e..e4150b2 100644
--- a/lib/aave-v3-core/contracts/protocol/tokenization/base/IncentivizedERC20.sol
+++ b/src/contracts/IncentivizedERC20.sol
@@ -1,16 +1,16 @@
 // SPDX-License-Identifier: BUSL-1.1
 pragma solidity 0.8.10;
 
-import {Context} from '../../../dependencies/openzeppelin/contracts/Context.sol';
-import {IERC20} from '../../../dependencies/openzeppelin/contracts/IERC20.sol';
-import {IERC20Detailed} from '../../../dependencies/openzeppelin/contracts/IERC20Detailed.sol';
-import {SafeCast} from '../../../dependencies/openzeppelin/contracts/SafeCast.sol';
-import {WadRayMath} from '../../libraries/math/WadRayMath.sol';
-import {Errors} from '../../libraries/helpers/Errors.sol';
-import {IAaveIncentivesController} from '../../../interfaces/IAaveIncentivesController.sol';
-import {IPoolAddressesProvider} from '../../../interfaces/IPoolAddressesProvider.sol';
-import {IPool} from '../../../interfaces/IPool.sol';
-import {IACLManager} from '../../../interfaces/IACLManager.sol';
+import {Context} from 'aave-v3-core/contracts/dependencies/openzeppelin/contracts/Context.sol';
+import {IERC20} from 'aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20.sol';
+import {IERC20Detailed} from 'aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20Detailed.sol';
+import {SafeCast} from 'aave-v3-core/contracts/dependencies/openzeppelin/contracts/SafeCast.sol';
+import {WadRayMath} from 'aave-v3-core/contracts/protocol/libraries/math/WadRayMath.sol';
+import {Errors} from 'aave-v3-core/contracts/protocol/libraries/helpers/Errors.sol';
+import {IAaveIncentivesController} from 'aave-v3-core/contracts/interfaces/IAaveIncentivesController.sol';
+import {IPoolAddressesProvider} from 'aave-v3-core/contracts/interfaces/IPoolAddressesProvider.sol';
+import {IPool} from 'aave-v3-core/contracts/interfaces/IPool.sol';
+import {IACLManager} from 'aave-v3-core/contracts/interfaces/IACLManager.sol';
 
 /**
  * @title IncentivizedERC20
@@ -45,7 +45,8 @@ abstract contract IncentivizedERC20 is Context, IERC20Detailed {
    * this field to store the user's stable rate.
    */
   struct UserState {
-    uint128 balance;
+    uint8 delegationState;
+    uint120 balance;
     uint128 additionalData;
   }
   // Map of users address and their state data (userAddress => userStateData)
```
