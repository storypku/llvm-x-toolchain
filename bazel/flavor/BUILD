package(default_visibility = ["//visibility:public"])

constraint_setting(name = "flavor")

constraint_value(
    name = "asan",
    constraint_setting = ":flavor",
)

constraint_value(
    name = "tsan",
    constraint_setting = ":flavor",
)

constraint_value(
    name = "ubsan",
    constraint_setting = ":flavor",
)
