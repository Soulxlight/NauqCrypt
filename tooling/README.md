# Reproducible Tooling

Build the research image with:

```sh
docker build --tag nauqcrypt-research:ec1 tooling
```

Run repository checks from the workspace root with:

```sh
docker run --rm -v "$PWD:/work" nauqcrypt-research:ec1
```

Run the pinned-tool smoke test with:

```sh
docker run --rm -v "$PWD:/work:ro" nauqcrypt-research:ec1 \
  sh /work/tooling/smoke-test.sh
```

Use `sh -c`, not `bash -lc`, for non-interactive checks. Debian's login-shell
profile replaces the Rust image's inherited `PATH`, hiding tools installed in
`/usr/local/cargo/bin`; the image itself and ordinary non-login shells retain
the correct path.

The base image is content-addressed. Security-relevant package and Cargo tool
versions are pinned in the Dockerfile. Each evidence run must also record the
built image ID because Debian dependency closure can change unless the package
mirror is archived. A release gate cannot call this environment bit-reproducible
until the final OCI image is exported and hashed.

EasyCrypt, Cryptol/SAW, Crux/Kani, dedicated trail-search tooling, AArch64
physical timing tools, and browser automation are added only after an
architecture survives; their exact versions will then be frozen before use.
