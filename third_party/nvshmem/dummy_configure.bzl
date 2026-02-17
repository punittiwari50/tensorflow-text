def _dummy_nvshmem_impl(repository_ctx):
    repository_ctx.file("BUILD", """
package(default_visibility = ["//visibility:public"])



load("@bazel_skylib//rules:common_settings.bzl", "bool_flag")

bool_flag(
    name = "include_nvshmem_libs",
    build_setting_default = False,
    visibility = ["//visibility:public"],
)
""")

dummy_nvshmem_configure = repository_rule(
    implementation = _dummy_nvshmem_impl,
)
