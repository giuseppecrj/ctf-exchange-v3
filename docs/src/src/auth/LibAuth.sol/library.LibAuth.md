# LibAuth
[Git Source](https://github.com/giuseppecrj/ctf-exchange-v3/blob/a29129a49e56939c55cc153379cf7f500fd1b22e/src/auth/LibAuth.sol)


## State Variables
### STORAGE_POSITION

```solidity
bytes32 constant STORAGE_POSITION = 0xedc1f61e78e46695bcdad1b91cef2e8df9fdb3b074121ad238ce6ace56c47300
```


## Functions
### initialize


```solidity
function initialize(Storage storage $, address admin) internal;
```

### isAdmin


```solidity
function isAdmin(Storage storage $, address caller) internal view returns (bool);
```

### isOperator


```solidity
function isOperator(Storage storage $, address caller) internal view returns (bool);
```

### addAdmin


```solidity
function addAdmin(Storage storage $, address admin) internal;
```

### addOperator


```solidity
function addOperator(Storage storage $, address operator) internal;
```

### removeAdmin


```solidity
function removeAdmin(Storage storage $, address admin) internal;
```

### removeOperator


```solidity
function removeOperator(Storage storage $, address operator) internal;
```

### renounceOperator


```solidity
function renounceOperator(Storage storage $) internal;
```

### _getLayout


```solidity
function _getLayout() internal pure returns (Storage storage $);
```

## Events
### NewAdmin
Emitted when a new admin is added


```solidity
event NewAdmin(address indexed newAdminAddress, address indexed admin);
```

### NewOperator
Emitted when a new operator is added


```solidity
event NewOperator(address indexed newOperatorAddress, address indexed admin);
```

### RemovedAdmin
Emitted when an admin is removed


```solidity
event RemovedAdmin(address indexed removedAdmin, address indexed admin);
```

### RemovedOperator
Emitted when an operator is removed


```solidity
event RemovedOperator(address indexed removedOperator, address indexed admin);
```

## Errors
### NotAdmin

```solidity
error NotAdmin();
```

### NotOperator

```solidity
error NotOperator();
```

### LastAdmin

```solidity
error LastAdmin();
```

### AlreadyAdmin

```solidity
error AlreadyAdmin();
```

### AlreadyOperator

```solidity
error AlreadyOperator();
```

## Structs
### Storage

```solidity
struct Storage {
    uint256 adminCount;
    mapping(address => bool) admins;
    mapping(address => bool) operators;
}
```

