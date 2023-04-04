```diff
diff --git a/lib/aave-v3-core/contracts/protocol/tokenization/base/MintableIncentivizedERC20.sol b/src/contracts/MintableIncentivizedERC20.sol
index 6d2120e..018f3da 100644
--- a/lib/aave-v3-core/contracts/protocol/tokenization/base/MintableIncentivizedERC20.sol
+++ b/src/contracts/MintableIncentivizedERC20.sol
@@ -1,8 +1,8 @@
 // SPDX-License-Identifier: BUSL-1.1
 pragma solidity 0.8.10;
 
-import {IAaveIncentivesController} from '../../../interfaces/IAaveIncentivesController.sol';
-import {IPool} from '../../../interfaces/IPool.sol';
+import {IAaveIncentivesController} from 'aave-v3-core/contracts/interfaces/IAaveIncentivesController.sol';
+import {IPool} from 'aave-v3-core/contracts/interfaces/IPool.sol';
 import {IncentivizedERC20} from './IncentivizedERC20.sol';
 
 /**
```
