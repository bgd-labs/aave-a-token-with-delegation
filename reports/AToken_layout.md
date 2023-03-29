{
  "storage": [
    {
      "astId": 1889,
      "contract": "lib/aave-v3-core/contracts/protocol/tokenization/AToken.sol:AToken",
      "label": "lastInitializedRevision",
      "offset": 0,
      "slot": "0",
      "type": "t_uint256"
    },
    {
      "astId": 1892,
      "contract": "lib/aave-v3-core/contracts/protocol/tokenization/AToken.sol:AToken",
      "label": "initializing",
      "offset": 0,
      "slot": "1",
      "type": "t_bool"
    },
    {
      "astId": 1962,
      "contract": "lib/aave-v3-core/contracts/protocol/tokenization/AToken.sol:AToken",
      "label": "______gap",
      "offset": 0,
      "slot": "2",
      "type": "t_array(t_uint256)50_storage"
    },
    {
      "astId": 3510,
      "contract": "lib/aave-v3-core/contracts/protocol/tokenization/AToken.sol:AToken",
      "label": "_userState",
      "offset": 0,
      "slot": "52",
      "type": "t_mapping(t_address,t_struct(UserState)3505_storage)"
    },
    {
      "astId": 3516,
      "contract": "lib/aave-v3-core/contracts/protocol/tokenization/AToken.sol:AToken",
      "label": "_allowances",
      "offset": 0,
      "slot": "53",
      "type": "t_mapping(t_address,t_mapping(t_address,t_uint256))"
    },
    {
      "astId": 3518,
      "contract": "lib/aave-v3-core/contracts/protocol/tokenization/AToken.sol:AToken",
      "label": "_totalSupply",
      "offset": 0,
      "slot": "54",
      "type": "t_uint256"
    },
    {
      "astId": 3520,
      "contract": "lib/aave-v3-core/contracts/protocol/tokenization/AToken.sol:AToken",
      "label": "_name",
      "offset": 0,
      "slot": "55",
      "type": "t_string_storage"
    },
    {
      "astId": 3522,
      "contract": "lib/aave-v3-core/contracts/protocol/tokenization/AToken.sol:AToken",
      "label": "_symbol",
      "offset": 0,
      "slot": "56",
      "type": "t_string_storage"
    },
    {
      "astId": 3524,
      "contract": "lib/aave-v3-core/contracts/protocol/tokenization/AToken.sol:AToken",
      "label": "_decimals",
      "offset": 0,
      "slot": "57",
      "type": "t_uint8"
    },
    {
      "astId": 3527,
      "contract": "lib/aave-v3-core/contracts/protocol/tokenization/AToken.sol:AToken",
      "label": "_incentivesController",
      "offset": 1,
      "slot": "57",
      "type": "t_contract(IAaveIncentivesController)923"
    },
    {
      "astId": 3344,
      "contract": "lib/aave-v3-core/contracts/protocol/tokenization/AToken.sol:AToken",
      "label": "_nonces",
      "offset": 0,
      "slot": "58",
      "type": "t_mapping(t_address,t_uint256)"
    },
    {
      "astId": 3346,
      "contract": "lib/aave-v3-core/contracts/protocol/tokenization/AToken.sol:AToken",
      "label": "_domainSeparator",
      "offset": 0,
      "slot": "59",
      "type": "t_bytes32"
    },
    {
      "astId": 2733,
      "contract": "lib/aave-v3-core/contracts/protocol/tokenization/AToken.sol:AToken",
      "label": "_treasury",
      "offset": 0,
      "slot": "60",
      "type": "t_address"
    },
    {
      "astId": 2735,
      "contract": "lib/aave-v3-core/contracts/protocol/tokenization/AToken.sol:AToken",
      "label": "_underlyingAsset",
      "offset": 0,
      "slot": "61",
      "type": "t_address"
    }
  ],
  "types": {
    "t_address": {
      "encoding": "inplace",
      "label": "address",
      "numberOfBytes": "20"
    },
    "t_array(t_uint256)50_storage": {
      "encoding": "inplace",
      "label": "uint256[50]",
      "numberOfBytes": "1600",
      "base": "t_uint256"
    },
    "t_bool": {
      "encoding": "inplace",
      "label": "bool",
      "numberOfBytes": "1"
    },
    "t_bytes32": {
      "encoding": "inplace",
      "label": "bytes32",
      "numberOfBytes": "32"
    },
    "t_contract(IAaveIncentivesController)923": {
      "encoding": "inplace",
      "label": "contract IAaveIncentivesController",
      "numberOfBytes": "20"
    },
    "t_mapping(t_address,t_mapping(t_address,t_uint256))": {
      "encoding": "mapping",
      "key": "t_address",
      "label": "mapping(address => mapping(address => uint256))",
      "numberOfBytes": "32",
      "value": "t_mapping(t_address,t_uint256)"
    },
    "t_mapping(t_address,t_struct(UserState)3505_storage)": {
      "encoding": "mapping",
      "key": "t_address",
      "label": "mapping(address => struct IncentivizedERC20.UserState)",
      "numberOfBytes": "32",
      "value": "t_struct(UserState)3505_storage"
    },
    "t_mapping(t_address,t_uint256)": {
      "encoding": "mapping",
      "key": "t_address",
      "label": "mapping(address => uint256)",
      "numberOfBytes": "32",
      "value": "t_uint256"
    },
    "t_string_storage": {
      "encoding": "bytes",
      "label": "string",
      "numberOfBytes": "32"
    },
    "t_struct(UserState)3505_storage": {
      "encoding": "inplace",
      "label": "struct IncentivizedERC20.UserState",
      "numberOfBytes": "32",
      "members": [
        {
          "astId": 3502,
          "contract": "lib/aave-v3-core/contracts/protocol/tokenization/AToken.sol:AToken",
          "label": "balance",
          "offset": 0,
          "slot": "0",
          "type": "t_uint128"
        },
        {
          "astId": 3504,
          "contract": "lib/aave-v3-core/contracts/protocol/tokenization/AToken.sol:AToken",
          "label": "additionalData",
          "offset": 16,
          "slot": "0",
          "type": "t_uint128"
        }
      ]
    },
    "t_uint128": {
      "encoding": "inplace",
      "label": "uint128",
      "numberOfBytes": "16"
    },
    "t_uint256": {
      "encoding": "inplace",
      "label": "uint256",
      "numberOfBytes": "32"
    },
    "t_uint8": {
      "encoding": "inplace",
      "label": "uint8",
      "numberOfBytes": "1"
    }
  }
}
