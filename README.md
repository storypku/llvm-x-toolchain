# Unified Clang-based Bazel Toolchains w/ CUDA and X-Compilation Support

## Introduction

Cross compilation is a common practice for embedded and autonomous driving systems.
As the time of this writing, configuration of Clang-based Bazel toolchains w/ CUDA
support on Linux was still challenging. As John Millikin pointed out([Ref](https://john-millikin.com/bazel-school/toolchains)):

> It assumes background knowledge in [cross compilation](https://en.wikipedia.org/wiki/Cross_compiler), plus experience with Bazel's [Starlark extension language](https://bazel.build/rules/language), [build rules](https://bazel.build/extending/rules), and [repository definitions](https://bazel.build/extending/repo). 
> Most users of Bazel shouldn't need to care about the details of compiler toolchains, but this is important stuff for maintainers of language rules.

This project was an attempt to address this issue, by integrating existing work by
[grailbio/bazel-toolchain](https://github.com/grailbio/bazel-toolchain) and [tf_runtime/rules_cuda](https://github.com/tensorflow/runtime/tree/master/third_party/rules_cuda). 


## Examples
Please refer to scripts in the `tests/scripts/run_tests` directory for examples.

## Requirements
Bazel 5.3 or newer (might work with older versions). This project was tested w/ Bazel 5.3.2 on Ubuntu 18.04 and 20.04.

## Known Issues

For my own use case, this project was tailored to work w/ LLVM/Clang >= 13.0.1 on Ubuntu releases >= 18.04 (Windows and MacOS
Support present in [grailbio/bazel-toolchain](https://github.com/grailbio/bazel-toolchain) was removed).

## Future Work
It seems the `rules_cuda` project inside [tensorflow/runtime](https://github.com/tensorflow/runtime/tree/master/third_party/rules_cuda) has evolved into an independent, full-fedged [CUDA rules for Bazel](https://github.com/bazel-contrib/rules_cuda) project.
So we might switch to using this repo as `cuda_library` implementation if possible.

## Credits

This work was impossible without these excellent projects besides Bazel.

1. The [LLVM toolchain for Bazel](https://github.com/grailbio/bazel-toolchain) project
2. The [tf_runtime/rules_cuda: CUDA rules for Bazel](https://github.com/tensorflow/runtime/tree/master/third_party/rules_cuda) project.
