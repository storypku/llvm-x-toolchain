load("@rules_cc//cc:defs.bzl", "cc_binary")
load("@rules_cuda//cuda:defs.bzl", "requires_cuda_enabled", _cuda_library = "cuda_library")

def cuda_library(name, **kwargs):
    """Macro wrapping a cc_library which can contain CUDA device code.

    Args:
      name: target name.
      **kwargs: forwarded to cuda_library rule from rules_cuda
    """
    target_compatible_with = kwargs.pop("target_compatible_with", []) + requires_cuda_enabled()
    _cuda_library(
        name = name,
        target_compatible_with = target_compatible_with,
        **kwargs
    )

def cuda_binary(name, **kwargs):
    target_compatible_with = kwargs.pop("target_compatible_with", []) + requires_cuda_enabled()
    srcs = kwargs.pop("srcs", None)
    if srcs:
        virtual_lib = name + "_virtual"
        visibility = kwargs.pop("visibility", None)
        _cuda_library(
            name = virtual_lib,
            srcs = srcs,
            target_compatible_with = target_compatible_with,
            visibility = ["//visibility:private"],
            **kwargs
        )

        deps = kwargs.pop("deps", []) + [virtual_lib]
        cc_binary(
            name = name,
            deps = deps,
            visibility = visibility,  # Restore visibility
            target_compatible_with = target_compatible_with,
            **kwargs
        )
    else:
        deps = kwargs.pop("deps", []) + ["@rules_cuda//cuda:cuda_runtime"]
        cc_binary(
            name = name,
            deps = deps,
            target_compatible_with = target_compatible_with,
            **kwargs
        )
