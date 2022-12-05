# Copyright 2021 The Bazel Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

SUPPORTED_TARGETS = [("linux", "x86_64"), ("linux", "aarch64")]

toolchain_tools = [
    "clang-cpp",
    "ld.lld",
    "llvm-ar",
    "llvm-dwp",
    "llvm-profdata",
    "llvm-cov",
    "llvm-nm",
    "llvm-objcopy",
    "llvm-objdump",
    "llvm-strip",
]

def python(rctx):
    # Get path of the python interpreter.
    python3 = rctx.which("python3")
    if python3:
        return python3
    python = rctx.which("python")
    if python:
        return python
    else:
        fail("Python not found")

def arch(rctx):
    result = rctx.execute([
        python(rctx),
        "-c",
        "import platform; print(platform.machine())",
    ])
    if result.return_code:
        fail("Failed to detect machine architecture: \n{}\n{}".format(result.stdout, result.stderr))
    return result.stdout.strip()

def os_arch_pair(os, arch):
    return "{}-{}".format(os, arch)

_supported_os_arch = ["linux-x86_64", "linux-aarch64"]

def supported_os_arch_keys():
    return _supported_os_arch

def check_os_arch_keys(keys):
    for k in keys:
        if k and k not in _supported_os_arch:
            fail("Unsupported {{os}}-{{arch}} key: {key}; valid keys are: {keys}".format(
                key = k,
                keys = ", ".join(_supported_os_arch),
            ))

def canonical_dir_path(path):
    if not path.endswith("/"):
        return path + "/"
    return path

def pkg_name_from_label(label):
    if label.workspace_name:
        return "@" + label.workspace_name + "//" + label.package
    else:
        return label.package

def pkg_path_from_label(label):
    if label.workspace_root:
        return label.workspace_root + "/" + label.package
    else:
        return label.package

def list_to_string(l):
    if l == None:
        return "None"
    return "[{}]".format(", ".join(["\"{}\"".format(d) for d in l]))
