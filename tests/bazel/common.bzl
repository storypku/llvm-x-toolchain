def if_cuda(if_true, if_false = []):
    """Shorthand for select()'ing on whether we're building with CUDA.

    Returns a select statement which evaluates to if_true if we're building
    with CUDA enabled.  Otherwise, the select statement evaluates to if_false.

    """
    return select({
        "@rules_cuda//cuda:is_cuda_enabled": if_true,
        "//conditions:default": if_false,
    })

def if_cpu_only(if_true, if_false = []):
    return if_cuda(if_false, if_true)

def if_x86_64(if_true, if_false = []):
    return select({
        "//bazel:linux_x86_64": if_true,
        "//conditions:default": if_false,
    })

def if_aarch64(if_true, if_false = []):
    return select({
        "//bazel:linux_aarch64": if_true,
        "//conditions:default": if_false,
    })

def if_x86_64_cpu_only(if_true, if_false = []):
    return select({
        "//bazel:linux_x86_64_cpu_only": if_true,
        "//conditions:default": if_false,
    })

def if_x86_64_cuda(if_true, if_false = []):
    return select({
        "//bazel:linux_x86_64_cuda": if_true,
        "//conditions:default": if_false,
    })

def if_aarch64_cpu_only(if_true, if_false = []):
    return select({
        "//bazel:linux_aarch64_cpu_only": if_true,
        "//conditions:default": if_false,
    })

def if_aarch64_cuda(if_true, if_false = []):
    return select({
        "//bazel:linux_aarch64_cuda": if_true,
        "//conditions:default": if_false,
    })

def if_xavier(if_true, if_false = []):
    return select({
        "//bazel:linux_xavier": if_true,
        "//conditions:default": if_false,
    })

def if_xavier_cpu_only(if_true, if_false = []):
    return select({
        "//bazel:linux_xavier_cpu_only": if_true,
        "//conditions:default": if_false,
    })

def if_xavier_cuda(if_true, if_false = []):
    return select({
        "//bazel:linux_xavier_cuda": if_true,
        "//conditions:default": if_false,
    })

def if_j5(if_true, if_false = []):
    return select({
        "//bazel:linux_j5": if_true,
        "//conditions:default": if_false,
    })
