def if_j5(if_true, if_false = []):
    return select({
        "//bazel/soctype:j5": if_true,
        "//conditions:default": if_false,
    })

def if_x9hp(if_true, if_false = []):
    return select({
        "//bazel/soctype:x9hp": if_true,
        "//conditions:default": if_false,
    })

def if_drive_orin(if_true, if_false = []):
    return select({
        "//bazel/soctype:drive_orin": if_true,
        "//conditions:default": if_false,
    })

def if_jetson_orin(if_true, if_false = []):
    return select({
        "//bazel/soctype:jetson_orin": if_true,
        "//conditions:default": if_false,
    })

def if_xavier(if_true, if_false = []):
    return select({
        "//bazel/soctype:xavier": if_true,
        "//conditions:default": if_false,
    })

def if_x86_64(if_true, if_false = []):
    return select({
        "@bazel_tools//platforms:x86_64": if_true,
        "//conditions:default": if_false,
    })

def if_aarch64(if_true, if_false = []):
    return select({
        "@bazel_tools//platforms:aarch64": if_true,
        "//conditions:default": if_false,
    })
