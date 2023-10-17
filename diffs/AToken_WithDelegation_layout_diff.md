```diff
diff --git a/reports/AToken_layout.md b/reports/ATokenWithDelegation_layout.md
index 9509585..09f2b29 100644
--- a/reports/AToken_layout.md
+++ b/reports/ATokenWithDelegation_layout.md
@@ -1,16 +1,19 @@
-| Name                                | Type                                                                  | Slot | Offset | Bytes |
-|-------------------------------------|-----------------------------------------------------------------------|------|--------|-------|
-| lastInitializedRevision             | uint256                                                               | 0    | 0      | 32    |
-| initializing                        | bool                                                                  | 1    | 0      | 1     |
-| ______gap                           | uint256[50]                                                           | 2    | 0      | 1600  |
-| _userState                          | mapping(address => struct IncentivizedERC20.UserState)                | 52   | 0      | 32    |
-| _allowances                         | mapping(address => mapping(address => uint256))                       | 53   | 0      | 32    |
-| _totalSupply                        | uint256                                                               | 54   | 0      | 32    |
-| _name                               | string                                                                | 55   | 0      | 32    |
-| _symbol                             | string                                                                | 56   | 0      | 32    |
-| _decimals                           | uint8                                                                 | 57   | 0      | 1     |
-| _incentivesController               | contract IAaveIncentivesController                                    | 57   | 1      | 20    |
-| _nonces                             | mapping(address => uint256)                                           | 58   | 0      | 32    |
-| _domainSeparator                    | bytes32                                                               | 59   | 0      | 32    |
-| _treasury                           | address                                                               | 60   | 0      | 20    |
-| _underlyingAsset                    | address                                                               | 61   | 0      | 20    |
+| Name                               | Type                                                                  | Slot | Offset | Bytes |
+|------------------------------------|-----------------------------------------------------------------------|------|--------|-------|
+| lastInitializedRevision            | uint256                                                               | 0    | 0      | 32    |
+| initializing                       | bool                                                                  | 1    | 0      | 1     |
+| ______gap                          | uint256[50]                                                           | 2    | 0      | 1600  |
+| _userState                         | mapping(address => struct IncentivizedERC20.UserState)                | 52   | 0      | 32    |
+| _allowances                        | mapping(address => mapping(address => uint256))                       | 53   | 0      | 32    |
+| _totalSupply                       | uint256                                                               | 54   | 0      | 32    |
+| _name                              | string                                                                | 55   | 0      | 32    |
+| _symbol                            | string                                                                | 56   | 0      | 32    |
+| _decimals                          | uint8                                                                 | 57   | 0      | 1     |
+| _incentivesController              | contract IAaveIncentivesController                                    | 57   | 1      | 20    |
+| _nonces                            | mapping(address => uint256)                                           | 58   | 0      | 32    |
+| _______DEPRECATED_DOMAIN_SEPARATOR | bytes32                                                               | 59   | 0      | 32    |
+| _treasury                          | address                                                               | 60   | 0      | 20    |
+| _underlyingAsset                   | address                                                               | 61   | 0      | 20    |
+| _votingDelegatee                   | mapping(address => address)                                           | 62   | 0      | 32    |
+| _propositionDelegatee              | mapping(address => address)                                           | 63   | 0      | 32    |
+| _delegatedState                    | mapping(address => struct ATokenWithDelegation.ATokenDelegationState) | 64   | 0      | 32    |
```
