# CTF Exchange V3

Solidity implementation of the Polymarket CTF exchange contracts, built with [Foundry](https://getfoundry.sh/).

## Overview

This repository contains exchange primitives for Conditional Tokens Framework (CTF) markets:

- `CTFExchange` entry point and initialization
- admin/operator authorization helpers
- asset configuration and CTF collateral references
- order, signature, matching, and trading data structures
- Polymarket proxy and Safe utility libraries

## Repository layout

```text
src/
  CTFExchange.sol          Exchange entry point
  Structs.sol              Shared exchange structs and enums
  assets/                  Collateral, CTF, and outcome token configuration
  auth/                    Admin/operator role management
  pausable/                User pause support
  trading/                 Trading interfaces and storage
  utils/                   Signature, proxy, Safe, and CTF helper libraries
scripts/                   Foundry deployment scripts
test/                      Foundry tests and test utilities
```

## Requirements

- [Foundry](https://getfoundry.sh/)
- Node.js package manager compatible with the lockfiles in this repo (`yarn` or `bun`)

Install dependencies:

```bash
yarn install
# or
bun install
```

## Development

Build contracts:

```bash
yarn build
# or
forge build
```

Run tests:

```bash
yarn test
# or
forge test
```

Run formatting and lint checks:

```bash
yarn lint
```

Generate coverage:

```bash
yarn test:coverage
```

## Deployment

Deployment scripts live in `scripts/`. The Makefile provides a generic script runner:

```bash
make deploy-any contract=DeployHello rpc=$RPC_URL private_key=$PRIVATE_KEY
```

Optional deployment context:

```bash
make deploy-any contract=DeployHello rpc=$RPC_URL private_key=$PRIVATE_KEY context=local
```

## Configuration

Foundry configuration is in `foundry.toml`:

- Solidity compiler: `0.8.33`
- EVM version: `shanghai`
- optimizer enabled with `10_000` runs
- default fuzz runs: `1_000`

RPC endpoints and explorer API keys are read from environment variables. Create a local `.env` file as needed; do not commit secrets.
