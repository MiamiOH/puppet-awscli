# == Class: awscli::deps::osx
#
# This module manages awscli dependencies for Darwin $::os['family'].
#
# @param pkg_dev
#   Development package required by the selected Python installation.
# @param pkg_pip
#   Pip package required by the selected Python installation.
# @param install_pkgdeps
#   Whether package development dependencies should be installed.
# @param install_pip
#   Whether pip should be installed.
class awscli::deps::osx (
  String $pkg_dev,
  String $pkg_pip,
  Boolean $install_pkgdeps,
  Boolean $install_pip,
) {
  if $install_pkgdeps {
    if !defined(Package[$pkg_dev]) {
      package { $pkg_dev:
        ensure   => installed,
        provider => homebrew,
      }
    }
  }

  if $install_pip {
    if !defined(Package[$pkg_pip]) {
      package { $pkg_pip:
        ensure   => installed,
        provider => homebrew,
      }
    }
  }
}
