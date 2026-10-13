# == Class: awscli::deps::redhat
#
# This module manages awscli dependencies for RedHat $facts['os']['family'].
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
#   Proxy used when configuring the EPEL repository.
#   Default: undef
#
# @param manage_epel
#   Whether the EPEL repository should be managed.
#   Default: true
#
class awscli::deps::redhat (
  String $pkg_dev,
  String $pkg_pip,
  Boolean $install_pkgdeps,
  Boolean $install_pip,
  Optional[String] $proxy = undef,
  Boolean $manage_epel = true,
) {
  if $manage_epel {
    if $proxy != undef {
      class { 'epel':
        epel_proxy => $proxy,
      }
    }
    else {
      include epel
    }

    Package { require => Class['epel'] }
  }

  if $install_pkgdeps {
    if !defined(Package[$pkg_dev]) {
      package { $pkg_dev:
        ensure => installed,
      }
    }
  }

  if $install_pip {
    if !defined(Package[$pkg_pip]) {
      package { $pkg_pip:
        ensure => installed,
      }
    }
  }
}
