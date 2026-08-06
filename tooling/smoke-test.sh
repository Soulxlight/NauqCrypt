#!/bin/sh
set -eu

rustc --version
cargo --version
cargo fuzz --version
cargo mutants --version
hyperfine --version
clang --version | sed -n '1p'
cvc5 --version | sed -n '1p'
z3 --version
boolector --version
afl-fuzz -h 2>&1 | sed -n '1p'
qemu-aarch64 --version | sed -n '1p'
valgrind --version

