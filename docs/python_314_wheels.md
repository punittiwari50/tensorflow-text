# Python 3.14 compatible Wheels

This directory contains wheels built manually for Python 3.14, as official releases were not available on PyPI at the time of build.

## Source Repositories

- **TensorFlow**: `tensorflow-2.21.0.dev0+selfbuilt-cp314-cp314-linux_x86_64.whl` (Provided locally)
- **dm-tree**: Built from [deepmind/tree](https://github.com/deepmind/tree.git)
    - Patched `CMakeLists.txt` to use `pybind11` v2.13.6 for CMake 3.20+ compatibility.
- **promise**: Built from [syrusakbary/promise](https://github.com/syrusakbary/promise.git)
- **libclang**: Built from [sighingnow/libclang](https://github.com/sighingnow/libclang.git)

## Usage

These wheels are located in `oss_scripts/pip_package/` and referenced in `requirements.in`.
Existing `third_party/wheels` directory was removed to avoid duplication.
