```diff
diff --git a/lib/aave-v3-factory/src/core/contracts/interfaces/IAtoken.sol b/src/contracts/interfaces/IAToken.sol
index 1379dff..e03ca51 100644
--- a/lib/aave-v3-factory/src/core/contracts/interfaces/IAtoken.sol
+++ b/src/contracts/interfaces/IAToken.sol
@@ -1,8 +1,8 @@
 // SPDX-License-Identifier: AGPL-3.0
 pragma solidity ^0.8.0;
 
-import {IERC20} from '../dependencies/openzeppelin/contracts/IERC20.sol';
-import {IScaledBalanceToken} from './IScaledBalanceToken.sol';
+import {IERC20} from 'aave-v3-factory/core/contracts/dependencies/openzeppelin/contracts/IERC20.sol';
+import {IScaledBalanceToken} from 'aave-v3-factory/core/contracts/interfaces/IScaledBalanceToken.sol';
 import {IInitializableAToken} from './IInitializableAToken.sol';
 
 /**
```
