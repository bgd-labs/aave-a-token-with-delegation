```diff
diff --git a/lib/aave-v3-factory/src/core/contracts/dependencies/openzeppelin/contracts/SafeCast.sol b/src/contracts/dependencies/SafeCast.sol
index fa24a0a..d9c9f08 100644
--- a/lib/aave-v3-factory/src/core/contracts/dependencies/openzeppelin/contracts/SafeCast.sol
+++ b/src/contracts/dependencies/SafeCast.sol
@@ -33,6 +33,21 @@ library SafeCast {
     return uint224(value);
   }
 
+  /**
+   * @dev Returns the downcasted uint120 from uint256, reverting on
+   * overflow (when the input is greater than largest uint120).
+   *
+   * Counterpart to Solidity's `uint120` operator.
+   *
+   * Requirements:
+   *
+   * - input must fit into 120 bits
+   */
+  function toUint120(uint256 value) internal pure returns (uint120) {
+    require(value <= type(uint120).max, "SafeCast: value doesn't fit in 120 bits");
+    return uint120(value);
+  }
+
   /**
    * @dev Returns the downcasted uint128 from uint256, reverting on
    * overflow (when the input is greater than largest uint128).
```
