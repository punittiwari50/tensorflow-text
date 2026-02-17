# Tools for building the TF.Text pip package.
load("@python//:defs.bzl", "compile_pip_requirements")
load("@python_version_repo//:py_version.bzl", "REQUIREMENTS")

package(default_visibility = ["//visibility:private"])

licenses(["notice"])  # Apache 2.0

compile_pip_requirements(
    name = "requirements",
    extra_args = [
        "--allow-unsafe",
        "--build-isolation",
        "--rebuild",
    ],
    requirements_in = "requirements.in",
    requirements_txt = "requirements_lock_3_14.txt",
    generate_hashes = True,
    data = [
        "tensorflow-2.21.0.dev0+selfbuilt-cp314-cp314-linux_x86_64.whl",
        "dm_tree-0.1.9-cp314-cp314-linux_x86_64.whl",
        "promise-2.3-py3-none-any.whl",
        "libclang-19.1.3-py2.py3-none-any.whl",
    ],
)

exports_files([
    "requirements.in",
    "tensorflow-2.21.0.dev0+selfbuilt-cp314-cp314-linux_x86_64.whl",
    "dm_tree-0.1.9-cp314-cp314-linux_x86_64.whl",
    "promise-2.3-py3-none-any.whl",
    "libclang-19.1.3-py2.py3-none-any.whl",
])

py_binary(
    name = "tensorflow_build_info",
    srcs = ["tensorflow_build_info.py"],
    deps = [
        "@absl_py//absl:app",
        "@release_or_nightly//:tensorflow_pkg",
    ],
)

py_binary(
    name = "build_pip_package",
    srcs = ["build_pip_package.py"],
    data = [
        "LICENSE",
        "MANIFEST.in",
        "setup.nightly.py",
        "setup.py",
        "//tensorflow_text",
        "//tensorflow_text/core/pybinds:pybinds_binaries",
    ],
    deps = [
        "@pypi_setuptools//:pkg",
    ],
)
