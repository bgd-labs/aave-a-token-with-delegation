```diff
diff --git a/lib/aave-v3-factory/src/core/contracts/interfaces/IAtoken.sol b/src/contracts/interfaces/IAToken.sol
index 9078c62..8a09de9 100644
--- a/lib/aave-v3-factory/src/core/contracts/interfaces/IAtoken.sol
+++ b/src/contracts/interfaces/IAToken.sol
@@ -1,8 +1,8 @@
-// SPDX-License-Identifier: MIT
+// SPDX-License-Identifier: AGPL-3.0
 pragma solidity ^0.8.0;
 
-import {IERC20} from '../dependencies/openzeppelin/contracts/IERC20.sol';
-import {IScaledBalanceToken} from './IScaledBalanceToken.sol';
+import {IERC20} from 'aave-v3-core/contracts/dependencies/openzeppelin/contracts/IERC20.sol';
+import {IScaledBalanceToken} from 'aave-v3-core/contracts/interfaces/IScaledBalanceToken.sol';
 import {IInitializableAToken} from './IInitializableAToken.sol';
 
 /**
```
