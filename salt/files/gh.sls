{% set gh_version = salt.config.get("gh:version") %}
{% set kernel = salt.grains.get("kernel") %}
{% set osarch = salt.grains.get("osarch") %}
install_gh:
  pkg.installed:
    - sources:
      - gh: "https://github.com/cli/cli/releases/download/v{{ gh_version }}/gh_{{ gh_version }}_{{ kernel | lower }}_{{ osarch }}.deb"
