
## What the difference among different unix `cc_toolchain_config` rules ?

You can run the following command to view the full diff.
```
bash cc_diff.sh
```

### Attributes
Currently, `cc_toolchain_config` rule from bazel.git have the following attributes
 which are missing from its counterpart in `rules_cc.git`.

```
"conly_flags": attr.string_list(),
"archive_flags": attr.string_list(),
"builtin_sysroot": attr.string(),
```

### Features
https://bazel.build/docs/cc-toolchain-config-reference#features

