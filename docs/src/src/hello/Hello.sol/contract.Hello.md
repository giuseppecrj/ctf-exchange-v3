# Hello
[Git Source](https://github.com/giuseppecrj/ctf-exchange-v3/blob/a29129a49e56939c55cc153379cf7f500fd1b22e/src/hello/Hello.sol)

**Inherits:**
[IHello](/src/hello/IHello.sol/interface.IHello.md)


## State Variables
### greeting

```solidity
string public greeting = "Hello, Forge!"
```


## Functions
### sayHello


```solidity
function sayHello() public view returns (string memory);
```

### setGreeting


```solidity
function setGreeting(string memory newGreeting) public;
```

## Events
### GreetingChanged

```solidity
event GreetingChanged(string oldGreeting, string newGreeting);
```

