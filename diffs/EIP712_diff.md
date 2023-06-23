```diff
diff --git a/reports/EIP712_prettier.sol b/src/contracts/dependencies/EIP712.sol
index f1fad72..91f4989 100644
--- a/reports/EIP712_prettier.sol
+++ b/src/contracts/dependencies/EIP712.sol
@@ -3,9 +3,9 @@
 
 pragma solidity ^0.8.10;
 
-import './ECDSA.sol';
-import '../ShortStrings.sol';
-import '../../interfaces/IERC5267.sol';
+import {ECDSA} from 'openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol';
+import {ShortStrings, ShortString} from 'openzeppelin-contracts/contracts/utils/ShortStrings.sol';
+import {IERC5267} from 'openzeppelin-contracts/contracts/interfaces/IERC5267.sol';
 
 /**
  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
@@ -49,8 +49,9 @@ abstract contract EIP712 is IERC5267 {
 
   ShortString private immutable _name;
   ShortString private immutable _version;
-  string private _nameFallback;
-  string private _versionFallback;
+
+  //  string private constant _nameFallback;
+  //  string private _versionFallback;
 
   /**
    * @dev Initializes the domain separator and parameter caches.
@@ -65,8 +66,8 @@ abstract contract EIP712 is IERC5267 {
    * contract upgrade].
    */
   constructor(string memory name, string memory version) {
-    _name = name.toShortStringWithFallback(_nameFallback);
-    _version = version.toShortStringWithFallback(_versionFallback);
+    _name = name.toShortString(); //name.toShortStringWithFallback(_nameFallback);
+    _version = version.toShortString(); //version.toShortStringWithFallback(_versionFallback);
     _hashedName = keccak256(bytes(name));
     _hashedVersion = keccak256(bytes(version));
 
@@ -150,7 +151,7 @@ abstract contract EIP712 is IERC5267 {
    */
   // solhint-disable-next-line func-name-mixedcase
   function _EIP712Name() internal view returns (string memory) {
-    return _name.toStringWithFallback(_nameFallback);
+    return _name.toString(); // _name.toStringWithFallback(_nameFallback);
   }
 
   /**
@@ -163,6 +164,6 @@ abstract contract EIP712 is IERC5267 {
    */
   // solhint-disable-next-line func-name-mixedcase
   function _EIP712Version() internal view returns (string memory) {
-    return _version.toStringWithFallback(_versionFallback);
+    return _version.toString(); // _version.toStringWithFallback(_versionFallback);
   }
 }
```
