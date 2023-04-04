```diff
diff --git a/lib/aave-v3-core/contracts/protocol/tokenization/base/ScaledBalanceTokenBase.sol b/src/contracts/ScaledBalanceTokenBase.sol
index d0010e5..73be0bb 100644
--- a/lib/aave-v3-core/contracts/protocol/tokenization/base/ScaledBalanceTokenBase.sol
+++ b/src/contracts/ScaledBalanceTokenBase.sol
@@ -1,11 +1,11 @@
 // SPDX-License-Identifier: BUSL-1.1
 pragma solidity 0.8.10;
 
-import {SafeCast} from '../../../dependencies/openzeppelin/contracts/SafeCast.sol';
-import {Errors} from '../../libraries/helpers/Errors.sol';
-import {WadRayMath} from '../../libraries/math/WadRayMath.sol';
-import {IPool} from '../../../interfaces/IPool.sol';
-import {IScaledBalanceToken} from '../../../interfaces/IScaledBalanceToken.sol';
+import {SafeCast} from 'aave-v3-core/contracts/dependencies/openzeppelin/contracts/SafeCast.sol';
+import {Errors} from 'aave-v3-core/contracts/protocol/libraries/helpers/Errors.sol';
+import {WadRayMath} from 'aave-v3-core/contracts/protocol/libraries/math/WadRayMath.sol';
+import {IPool} from 'aave-v3-core/contracts/interfaces/IPool.sol';
+import {IScaledBalanceToken} from 'aave-v3-core/contracts/interfaces/IScaledBalanceToken.sol';
 import {MintableIncentivizedERC20} from './MintableIncentivizedERC20.sol';
 
 /**
```
