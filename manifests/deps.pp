# == Class: awscli::deps
#
# This module manages awscli dependencies and should *not* be called directly.
#
#
# @param pkg_dev
#   Development package required by the selected Python installation.
# @param pkg_pip
#   Pip package required by the selected Python installation.
# @param install_pkgdeps
#   Whether package development dependencies should be installed.
# @param install_pip
#   Whether pip should be installed.
# @param proxy
#   Proxy used when configuring dependencies.
#   Default: undef
# @param manage_epel
#   Manage EPEL.
#
class awscli::deps (
  String $pkg_dev,
  String $pkg_pip,
  Boolean $install_pkgdeps,
  Boolean $install_pip,
  Optional[String] $proxy = undef,
  Boolean $manage_epel = true,
) {
  case $facts['os']['family'] {
    'Debian': {
      class { 'awscli::deps::debian':
        pkg_dev         => $pkg_dev,
        pkg_pip         => $pkg_pip,
        install_pkgdeps => $install_pkgdeps,
        install_pip     => $install_pip,
      }
      contain awscli::deps::debian
    }

    'RedHat': {
      class { 'awscli::deps::redhat':
        pkg_dev         => $pkg_dev,
        pkg_pip         => $pkg_pip,
        install_pkgdeps => $install_pkgdeps,
        install_pip     => $install_pip,
        proxy           => $proxy,
        manage_epel     => $manage_epel,
      }
      contain awscli::deps::redhat
    }

    'Darwin': {
      class { 'awscli::deps::osx':
        pkg_dev         => $pkg_dev,
        pkg_pip         => $pkg_pip,
        install_pkgdeps => $install_pkgdeps,
        install_pip     => $install_pip,
      }
      contain awscli::deps::osx
    }

    default: {
      fail("The awscli module does not support ${facts['os']['family']}")
    }
  }
}
