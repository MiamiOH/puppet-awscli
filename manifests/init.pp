# == Class: awscli
#
# Install awscli
#
# === Parameters
#
# @param version
#   Provides ability to change the version of awscli being installed.
#   Default: 'present'
#
# @param pkg_dev
#   Provides ability to install a specific development package by name.
#   Default: Hiera value.
#
# @param pkg_pip
#   Provides ability to install a specific PIP package by name.
#   Default: Hiera value.
#
# @param manage_epel
#   Boolean flag to install the EPEL repositories.
#   Default: true
#
# @param install_pkgdeps
#   Boolean flag to install package dependencies.
#   Default: true
#
# @param install_pip
#   Boolean flag to install pip.
#   Default: true
#
# @param provider
#   Package provider to use. Typically 'pip', 'pip3', or the system package
#   provider.
#
# @param proxy
#   Proxy used when configuring the EPEL repository.
#   Default: undef
#
# @param install_options
#   Array of install options for the awscli PIP package.
#   Default: undef
#
# === Examples
#
#  class { awscli: }
#
# === Authors
#
# Justin Downing <justin@downing.us>
#
# === Copyright
#
# Copyright 2014 Justin Downing
#
class awscli (
  String $version,
  String $pkg_dev,
  String $pkg_pip,
  Boolean $manage_epel,
  Boolean $install_pkgdeps,
  Boolean $install_pip,
  String $provider,
  Optional[String] $proxy = undef,
  Optional[Array[String]] $install_options = undef,
) {
  case $provider {
    'pip', 'pip3': {
      class { 'awscli::deps':
        pkg_dev         => $pkg_dev,
        pkg_pip         => $pkg_pip,
        install_pkgdeps => $install_pkgdeps,
        install_pip     => $install_pip,
        proxy           => $proxy,
        manage_epel     => $manage_epel,
      }

      if $install_pip {
        package { 'awscli':
          ensure          => $version,
          provider        => $provider,
          install_options => $install_options,
          require         => [
            Package[$pkg_pip],
            Class['awscli::deps'],
          ],
        }
      } else {
        package { 'awscli':
          ensure          => $version,
          provider        => $provider,
          install_options => $install_options,
          require         => Class['awscli::deps'],
        }
      }
    }

    default: {
      package { 'awscli':
        ensure => $version,
      }
    }
  }
}
