load("//third_party/llvm_repo:llvm_repo.bzl", "local_llvm_repo", "remote_llvm_repo")

_DEFAULT_LLVM_VERSION = "13.0.1"
_LLVM_REPO = "llvm_repo"

def repo(use_local = True, llvm_version = None, llvm_dir = None):
    if native.existing_rule(_LLVM_REPO):
        return

    llvm_version = llvm_version or _DEFAULT_LLVM_VERSION
    if use_local:
        local_llvm_repo(
            name = _LLVM_REPO,
            llvm_version = llvm_version,
            llvm_dir = llvm_dir,
        )
    else:
        remote_llvm_repo(
            name = _LLVM_REPO,
            llvm_version = llvm_version,
        )
