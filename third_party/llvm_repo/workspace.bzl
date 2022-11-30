load("//third_party/llvm_repo:llvm_repo.bzl", "local_llvm_repo", "remote_llvm_repo")

_DEFAULT_LLVM_VERSION = "13.0.1"

def repo(use_local = True, llvm_version = _DEFAULT_LLVM_VERSION, llvm_dir = None):
    if use_local:
        local_llvm_repo(
            name = "llvm_repo",
            llvm_version = llvm_version,
            llvm_dir = llvm_dir,
        )
    else:
        remote_llvm_repo(
            name = "llvm_repo",
            llvm_version = llvm_version,
        )
