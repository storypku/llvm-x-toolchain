load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def clean_dep(dep):
    return str(Label(dep))

def repo():
    absl_version = "20220623.1"
    if not native.existing_rule("com_google_absl"):
        http_archive(
            name = "com_google_absl",
            strip_prefix = "abseil-cpp-{}".format(absl_version),
            sha256 = "91ac87d30cc6d79f9ab974c51874a704de9c2647c40f6932597329a282217ba8",
            patch_args = ["-p1"],
            patches = [
                clean_dep("//third_party/absl:p01_deprecated_builtins.patch"),
                clean_dep("//third_party/absl:p02_deprecated_builtins.patch"),
            ],
            urls = [
                "https://github.com/abseil/abseil-cpp/archive/refs/tags/{}.tar.gz".format(absl_version),
            ],
        )
