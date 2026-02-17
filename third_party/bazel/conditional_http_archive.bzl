
"""Conditional http_archive."""

def _conditional_http_archive_impl(ctx):
  is_nightly = ctx.os.environ.get("IS_NIGHTLY") == "nightly"
  urls = ctx.attr.urls
  sha256 = ctx.attr.sha256
  strip_prefix = ctx.attr.strip_prefix
  if is_nightly:
      if ctx.attr.nightly_urls:
          urls = ctx.attr.nightly_urls
      sha256 = ctx.attr.nightly_sha256
      if ctx.attr.nightly_strip_prefix:
          strip_prefix = ctx.attr.nightly_strip_prefix

  ctx.download_and_extract(
      url = urls,
      sha256 = sha256,
      stripPrefix = strip_prefix,
  )
  if ctx.attr.build_file:
      ctx.file("BUILD", ctx.read(ctx.attr.build_file))
  if ctx.attr.patches:
      for patch in ctx.attr.patches:
          ctx.patch(patch, strip=1)

conditional_http_archive = repository_rule(
    implementation = _conditional_http_archive_impl,
    attrs = {
        "build_file": attr.label(),
        "patches": attr.label_list(),
        "sha256": attr.string(),
        "strip_prefix": attr.string(),
        "urls": attr.string_list(),
        "nightly_sha256": attr.string(),
        "nightly_strip_prefix": attr.string(),
        "nightly_urls": attr.string_list(),
    },
)
