```diff
diff --git a/lib/aave-v3-factory/src/core/contracts/interfaces/IInitializableAToken.sol b/src/contracts/interfaces/IInitializableAToken.sol
index fdc1858..1863624 100644
--- a/lib/aave-v3-factory/src/core/contracts/interfaces/IInitializableAToken.sol
+++ b/src/contracts/interfaces/IInitializableAToken.sol
@@ -1,8 +1,8 @@
-// SPDX-License-Identifier: MIT
+// SPDX-License-Identifier: AGPL-3.0
 pragma solidity ^0.8.0;
 
-import {IAaveIncentivesController} from './IAaveIncentivesController.sol';
-import {IPool} from './IPool.sol';
+import {IAaveIncentivesController} from 'aave-v3-core/contracts/interfaces/IAaveIncentivesController.sol';
+import {IPool} from 'aave-v3-core/contracts/interfaces/IPool.sol';
 
 /**
  * @title IInitializableAToken
```
