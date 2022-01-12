# The Verification of the Crypto-supported RISC-V Ibex core

<!--- -------------------------------------------------------------------- --->

## Overview

This is a repository for the source codes to verify the modified Ibex core supporting the Scalar Cryptography Extension (Zk V1.0.0) [1], [2].
The verification consists of two test cases. The first one is random custom test, and the other is based on the compliance test.


<!--- -------------------------------------------------------------------- --->

## Organisation

```
├── bin                - scripts (e.g., environment configuration)
├── doc                - consists of the Zk encoding and other documents
├── src                - source code
│   ├── hw             - source code for set up Crypto-supported ibex rtl and its FPGA implementation
│   └── sw             - source code for testing software
│       ├── test-zkn   - the testing program for Zkn instructions 
│       └── test-zks   - the testing program for Zks instructions
├── toolchain          - scripts to set up the toolchain for the Scalar Cryptography Extension and the compliance tests
└── build              - working directory for build

```

<!--- -------------------------------------------------------------------- --->

## Quickstart

- For seting up the repository

  - Clone the repository and setup environment
  
    ```sh
    git clone https://github.com/scarv/crypto-ibex ./crypto-ibex
    cd ./crypto-ibex
    source bin/conf.sh
    ```

  - Fix paths for the RISCV toolchains and ibex repos, e.g., 
  
    ```sh
    export RISCV=./build/riscv
    export IBEX_REPO=./build/ibex
    ```

  - Build the Crypto-supported RISC-V toolchain
    [Warning!: it requires about 11 GB and takes 45 mins to clone and build the toolchain]
    ```sh
    make -C toolchain/ get-gnu-toolchain
    ```
  
  - Build the RISC-V compliance tests

    ```sh
    make -C toolchain/ get-arch-test
    ```

  - Clone and set-up the Crypto-ibex

    ```sh
    make -C src/hw/ ibex-clone 
    ```
  
- Build and execute the verification for the Crypto-Ibex, e.g.,

  ```sh
  make -C src/sw/ -B run-sw SW=test-zkn IBEX_CONFIG=experimental-maxperf-pmp-zkn
  ```

  Or

  ```sh
  make -C src/sw/ -B run-sw SW=test-zks IBEX_CONFIG=experimental-maxperf-pmp-zks
  ```
  
  Check build/test-[zkn/zks]/ibex_simple_system.log for the result. 

- Build and execute the K extension RISC-V compliance test for the Crypto-Ibex, e.g.,

  ```sh
  make -C src/sw/ -B run-riscv-arch-test IBEX_CONFIG=experimental-maxperf-pmp-zkn
  ```
  The test is failed at the Zks instructions, i.e., sm3* and sm4* instructions. These instructions are checked as follows;

  ```sh
  make -C src/sw/ -B run-riscv-arch-test IBEX_CONFIG=experimental-maxperf-pmp-zks
  ```

## References

[1] RISC-V Scalar Cryptography Extension Specification, https://github.com/riscv/riscv-crypto/releases/tag/v1.0.0-rc6-scalar/riscv-crypto-spec-scalar-1.0.0-rc6.pdf 

[2] Implementing the Draft RISC-V Scalar Cryptography Extensions, https://dl.acm.org/doi/pdf/10.1145/3458903.3458904

## Acknowledgements

This work has been supported in part
by EPSRC via grant
[EP/R012288/1](https://gow.epsrc.ukri.org/NGBOViewGrant.aspx?GrantRef=EP/R012288/1) (under the [RISE](http://www.ukrise.org) programme).
