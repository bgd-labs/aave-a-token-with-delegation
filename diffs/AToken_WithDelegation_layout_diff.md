```diff
diff --git a/reports/AToken_layout.md b/reports/ATokenWithDelegation_layout.md
index 90165cd..09f2b29 100644
--- a/reports/AToken_layout.md
+++ b/reports/ATokenWithDelegation_layout.md
@@ -11,6 +11,9 @@
 | _decimals                          | uint8                                                                 | 57   | 0      | 1     |
 | _incentivesController              | contract IAaveIncentivesController                                    | 57   | 1      | 20    |
 | _nonces                            | mapping(address => uint256)                                           | 58   | 0      | 32    |
-| _domainSeparator                   | bytes32                                                               | 59   | 0      | 32    |
+| _______DEPRECATED_DOMAIN_SEPARATOR | bytes32                                                               | 59   | 0      | 32    |
 | _treasury                          | address                                                               | 60   | 0      | 20    |
 | _underlyingAsset                   | address                                                               | 61   | 0      | 20    |
+| _votingDelegatee                   | mapping(address => address)                                           | 62   | 0      | 32    |
+| _propositionDelegatee              | mapping(address => address)                                           | 63   | 0      | 32    |
+| _delegatedState                    | mapping(address => struct ATokenWithDelegation.ATokenDelegationState) | 64   | 0      | 32    |
```
