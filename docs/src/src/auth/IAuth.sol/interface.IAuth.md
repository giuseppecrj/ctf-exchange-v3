# IAuth
[Git Source](https://github.com/giuseppecrj/ctf-exchange-v3/blob/a29129a49e56939c55cc153379cf7f500fd1b22e/src/auth/IAuth.sol)

**Title:**
IAuth

External interface for admin and operator role management on the exchange.


## Functions
### isAdmin

Returns whether `account` holds the admin role.


```solidity
function isAdmin(address account) external view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`account`|`address`|The address to query.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|True if `account` is an admin.|


### isOperator

Returns whether `account` holds the operator role.


```solidity
function isOperator(address account) external view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`account`|`address`|The address to query.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|True if `account` is an operator.|


### addAdmin

Grants the admin role to `admin`.

Callable only by an existing admin. Reverts if `admin` is already an admin.


```solidity
function addAdmin(address admin) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`admin`|`address`|The address to grant admin privileges.|


### addOperator

Grants the operator role to `operator`.

Callable only by an admin. Reverts if `operator` is already an operator.


```solidity
function addOperator(address operator) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`operator`|`address`|The address to grant operator privileges.|


### removeAdmin

Revokes the admin role from `admin`.

Callable only by an admin. Reverts if `admin` is not an admin.


```solidity
function removeAdmin(address admin) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`admin`|`address`|The address to remove from admins.|


### removeOperator

Revokes the operator role from `operator`.

Callable only by an admin. Reverts if `operator` is not an operator.


```solidity
function removeOperator(address operator) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`operator`|`address`|The address to remove from operators.|


### renounceOperatorRole

Revokes the operator role from the caller.

Callable only by the caller when they hold the operator role.


```solidity
function renounceOperatorRole() external;
```

