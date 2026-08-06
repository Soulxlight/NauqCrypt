FROM rust:1.96.0-bookworm@sha256:5e2214abe154fe26e39f64488952e5c991eeed1d6d6da7cc8381ae83927f0cfc

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        afl++=4.04c-4 \
        boolector=1.5.118.6b56be4.121013-1.3 \
        build-essential \
        ca-certificates \
        clang=1:14.0-55.7~deb12u1 \
        cmake=3.25.1-1 \
        curl \
        cvc5=1.0.3-1 \
        gcc-multilib \
        git \
        jq \
        libc6-dev-i386 \
        ninja-build=1.11.1-2~deb12u1 \
        pkg-config \
        python3 \
        python3-pip \
        python3-venv \
        qemu-user=1:7.2+dfsg-7+deb12u18+b3 \
        valgrind=1:3.19.0-1 \
        z3=4.8.12-3.1 \
    && rm -rf /var/lib/apt/lists/*

RUN rustup component add clippy rustfmt llvm-tools-preview \
    && rustup target add i686-unknown-linux-gnu wasm32-wasip1 \
    && cargo install --locked cargo-fuzz --version 0.13.2 \
    && cargo install --locked cargo-mutants --version 27.1.0 \
    && cargo install --locked hyperfine --version 1.20.0

WORKDIR /work

CMD ["bash"]

