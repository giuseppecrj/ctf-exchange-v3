# AuthFacet
[Git Source](https://github.com/giuseppecrj/ctf-exchange-v3/blob/a29129a49e56939c55cc153379cf7f500fd1b22e/src/auth/Auth.sol)

**Inherits:**
[IAuth](/src/auth/IAuth.sol/interface.IAuth.md), Facet


## State Variables
### adminAuth

```solidity
LibAuth.Storage adminAuth
```


## Functions
### __AuthFacet_init


```solidity
function __AuthFacet_init(address admin) internal onlyInitializing;
```

### isAdmin

Returns whether `account` holds the admin role.


```solidity
function isAdmin(address caller) external view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`caller`|`address`||

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|True if `account` is an admin.|


### isOperator


```solidity
function isOperator(address caller) external view returns (bool);
```

### addAdmin


```solidity
function addAdmin(address admin) external;
```

### addOperator


```solidity
function addOperator(address operator) external;
```

### removeAdmin


```solidity
function removeAdmin(address admin) external;
```

### removeOperator


```solidity
function removeOperator(address operator) external;
```

### renounceOperatorRole


```solidity
function renounceOperatorRole() external;
```

