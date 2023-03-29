{
  "storage": [
    {
      "astId": 2943,
      "contract": "src/contracts/ATokenWithDelegation.sol:ATokenWithDelegation",
      "label": "lastInitializedRevision",
      "offset": 0,
      "slot": "0",
      "type": "t_uint256"
    },
    {
      "astId": 2946,
      "contract": "src/contracts/ATokenWithDelegation.sol:ATokenWithDelegation",
      "label": "initializing",
      "offset": 0,
      "slot": "1",
      "type": "t_bool"
    },
    {
      "astId": 3016,
      "contract": "src/contracts/ATokenWithDelegation.sol:ATokenWithDelegation",
      "label": "______gap",
      "offset": 0,
      "slot": "2",
      "type": "t_array(t_uint256)50_storage"
    },
    {
      "astId": 4564,
      "contract": "src/contracts/ATokenWithDelegation.sol:ATokenWithDelegation",
      "label": "_userState",
      "offset": 0,
      "slot": "52",
      "type": "t_mapping(t_address,t_struct(UserState)4559_storage)"
    },
    {
      "astId": 4570,
      "contract": "src/contracts/ATokenWithDelegation.sol:ATokenWithDelegation",
      "label": "_allowances",
      "offset": 0,
      "slot": "53",
      "type": "t_mapping(t_address,t_mapping(t_address,t_uint256))"
    },
    {
      "astId": 4572,
      "contract": "src/contracts/ATokenWithDelegation.sol:ATokenWithDelegation",
      "label": "_totalSupply",
      "offset": 0,
      "slot": "54",
      "type": "t_uint256"
    },
    {
      "astId": 4574,
      "contract": "src/contracts/ATokenWithDelegation.sol:ATokenWithDelegation",
      "label": "_name",
      "offset": 0,
      "slot": "55",
      "type": "t_string_storage"
    },
    {
      "astId": 4576,
      "contract": "src/contracts/ATokenWithDelegation.sol:ATokenWithDelegation",
      "label": "_symbol",
      "offset": 0,
      "slot": "56",
      "type": "t_string_storage"
    },
    {
      "astId": 4578,
      "contract": "src/contracts/ATokenWithDelegation.sol:ATokenWithDelegation",
      "label": "_decimals",
      "offset": 0,
      "slot": "57",
      "type": "t_uint8"
    },
    {
      "astId": 4581,
      "contract": "src/contracts/ATokenWithDelegation.sol:ATokenWithDelegation",
      "label": "_incentivesController",
      "offset": 1,
      "slot": "57",
      "type": "t_contract(IAaveIncentivesController)1977"
    },
    {
      "astId": 4398,
      "contract": "src/contracts/ATokenWithDelegation.sol:ATokenWithDelegation",
      "label": "_nonces",
      "offset": 0,
      "slot": "58",
      "type": "t_mapping(t_address,t_uint256)"
    },
    {
      "astId": 4400,
      "contract": "src/contracts/ATokenWithDelegation.sol:ATokenWithDelegation",
      "label": "_domainSeparator",
      "offset": 0,
      "slot": "59",
      "type": "t_bytes32"
    },
    {
      "astId": 3787,
      "contract": "src/contracts/ATokenWithDelegation.sol:ATokenWithDelegation",
      "label": "_treasury",
      "offset": 0,
      "slot": "60",
      "type": "t_address"
    },
    {
      "astId": 3789,
      "contract": "src/contracts/ATokenWithDelegation.sol:ATokenWithDelegation",
      "label": "_underlyingAsset",
      "offset": 0,
      "slot": "61",
      "type": "t_address"
    },
    {
      "astId": 19,
      "contract": "src/contracts/ATokenWithDelegation.sol:ATokenWithDelegation",
      "label": "_votingDelegatee",
      "offset": 0,
      "slot": "62",
      "type": "t_mapping(t_address,t_address)"
    },
    {
      "astId": 23,
      "contract": "src/contracts/ATokenWithDelegation.sol:ATokenWithDelegation",
      "label": "_propositionDelegatee",
      "offset": 0,
      "slot": "63",
      "type": "t_mapping(t_address,t_address)"
    },
    {
      "astId": 5642,
      "contract": "src/contracts/ATokenWithDelegation.sol:ATokenWithDelegation",
      "label": "_delegatedBalances",
      "offset": 0,
      "slot": "64",
      "type": "t_mapping(t_address,t_struct(DelegationBalance)15_storage)"
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
    "t_contract(IAaveIncentivesController)1977": {
      "encoding": "inplace",
      "label": "contract IAaveIncentivesController",
      "numberOfBytes": "20"
    },
    "t_enum(DelegationState)945": {
      "encoding": "inplace",
      "label": "enum DelegationState",
      "numberOfBytes": "1"
    },
    "t_mapping(t_address,t_address)": {
      "encoding": "mapping",
      "key": "t_address",
      "label": "mapping(address => address)",
      "numberOfBytes": "32",
      "value": "t_address"
    },
    "t_mapping(t_address,t_mapping(t_address,t_uint256))": {
      "encoding": "mapping",
      "key": "t_address",
      "label": "mapping(address => mapping(address => uint256))",
      "numberOfBytes": "32",
      "value": "t_mapping(t_address,t_uint256)"
    },
    "t_mapping(t_address,t_struct(DelegationBalance)15_storage)": {
      "encoding": "mapping",
      "key": "t_address",
      "label": "mapping(address => struct BaseDelegation.DelegationBalance)",
      "numberOfBytes": "32",
      "value": "t_struct(DelegationBalance)15_storage"
    },
    "t_mapping(t_address,t_struct(UserState)4559_storage)": {
      "encoding": "mapping",
      "key": "t_address",
      "label": "mapping(address => struct IncentivizedERC20.UserState)",
      "numberOfBytes": "32",
      "value": "t_struct(UserState)4559_storage"
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
    "t_struct(DelegationBalance)15_storage": {
      "encoding": "inplace",
      "label": "struct BaseDelegation.DelegationBalance",
      "numberOfBytes": "32",
      "members": [
        {
          "astId": 9,
          "contract": "src/contracts/ATokenWithDelegation.sol:ATokenWithDelegation",
          "label": "delegatedPropositionBalance",
          "offset": 0,
          "slot": "0",
          "type": "t_uint72"
        },
        {
          "astId": 11,
          "contract": "src/contracts/ATokenWithDelegation.sol:ATokenWithDelegation",
          "label": "delegatedVotingBalance",
          "offset": 9,
          "slot": "0",
          "type": "t_uint72"
        },
        {
          "astId": 14,
          "contract": "src/contracts/ATokenWithDelegation.sol:ATokenWithDelegation",
          "label": "delegationState",
          "offset": 18,
          "slot": "0",
          "type": "t_enum(DelegationState)945"
        }
      ]
    },
    "t_struct(UserState)4559_storage": {
      "encoding": "inplace",
      "label": "struct IncentivizedERC20.UserState",
      "numberOfBytes": "32",
      "members": [
        {
          "astId": 4556,
          "contract": "src/contracts/ATokenWithDelegation.sol:ATokenWithDelegation",
          "label": "balance",
          "offset": 0,
          "slot": "0",
          "type": "t_uint128"
        },
        {
          "astId": 4558,
          "contract": "src/contracts/ATokenWithDelegation.sol:ATokenWithDelegation",
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
    "t_uint72": {
      "encoding": "inplace",
      "label": "uint72",
      "numberOfBytes": "9"
    },
    "t_uint8": {
      "encoding": "inplace",
      "label": "uint8",
      "numberOfBytes": "1"
    }
  }
}