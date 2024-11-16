# Pana Oracle v1
The Darli Pana Price Feed is a Solidity implementation of an immutable Oracle Factory contract that allows anyone to deploy a new Oracle. Each Oracle contract allows Darli governance token holders to participate in price voting by staking tokens in a pool. The Oracle keeps track of staked tokens and allows Darli token holders to vote on a price, which can then be retrieved by other contracts.

## Structure
### Oracle Factory Contract
A factory contract to deploy new Oracle contracts.

### Oracle Contract
The core contract for price voting by staked Darli governance token holders.

### Test
Test folder demonstrates a test for Oracle contract, and a Hardhat Ignition module that deploys that contract.
Try running some of the following tasks:

```shell
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/Oracle.js
```

### Reporter CLI
This package includes a CLI script for deploying the latest Pana Oracle V1 smart contracts to any EVM (Ethereum Virtual Machine) compatible network.

### Reporter SDK
This repository contains a set of SDKs for reporters to easily publish "reporter" data in any supported languages. We currently support the following languages:
JavaScript

## Contributing
Note: all code contributed to this repository must be licensed under each of 1. MIT, 2. BSD-3, and 3. GPLv3. By contributing code to this repository, you accept that your code is allowed to be released under any or all of these licenses or licenses in substantially similar form to these listed above.

Please submit an issue (or create a pull request) for any issues or contributions to the project. Make sure that all test cases pass, including the integration tests in the root of this project.
