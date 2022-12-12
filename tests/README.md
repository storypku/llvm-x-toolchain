# LLVM-X-Toolchain-Test

This repository holds tests for the llvm-x-toolchain project.

## Requirements

1. LLVM/Clang Distribution

Currently, the supported list of LLVM distributions is:

- 13.0.1
- 14.0.0
- 15.0.6

By default, LLVM/Clang 15.0.6 should be downloaded and extracted as `/opt/llvm`.

You can tweak the default behavior by editing the [WORKSPACE](WORKSPACE) file:

```
# Use locally installed LLVM/Clang dist version at /path/to/my/llvm/dist
llvm_x_toolchain_repositories(use_local_llvm = True, llvm_version = "14.0.0", llvm_dir = "/path/to/my/llvm/dist")
```

OR

```
# Let Bazel download LLVM/Clang dist for you.
llvm_x_toolchain_repositories(use_local_llvm = False, llvm_version = "15.0.6")
```

2. CUDA Toolkits 11.x should be installed on `x86_64` systems with a NVIDIA GPU to test CUDA support for Native Compilation.
Alternatively, you can use JetPack X-Compilation Docker to test for both Native and Cross Compilation.


## How to Test w/ JetPack-X-Docker

1. Make sure you have Docker installed.

2. Run the following commands to start and login to JetPack-X-Docker

```
./scripts/start_x_docker.sh
./scripts/goto_x_docker.sh
```

By default, if you have LLVM/Clang dist locally at `/opt/llvm`, the commands above will
mount it for you.

3. Make sure you have Bazel installed

There is a dedicated script to install Bazel for you:

```
sudo ./scripts/installers/install_bazel.sh
```
