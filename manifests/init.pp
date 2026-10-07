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
#   Default: See awscli::params.
#
# @param pkg_pip
#   Provides ability to install a specific PIP package by name.
#   Default: See awscli::params.
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
  String $version = 'present',
  String $pkg_dev = $awscli::params::pkg_dev,
  String $pkg_pip = $awscli::params::pkg_pip,
  Boolean $manage_epel = true,
  Boolean $install_pkgdeps = true,
  Boolean $install_pip = true,
  String $provider = $awscli::params::pkg_provider,
  Optional[String] $proxy = $awscli::params::proxy,
  Optional[Array[String]] $install_options = $awscli::params::install_options,
) inherits awscli::params {
  case $provider {
    'pip','pip3': {
      class { 'awscli::deps':
        proxy => $proxy,
      }

      package { 'awscli':
        ensure          => $version,
        provider        => $provider,
        install_options => $install_options,
        require         => [
          Package[$pkg_pip],
          Class['awscli::deps'],
        ],
      }
    }

    default: {
      package { 'awscli':
        ensure => $version,
      }
    }
  }
}
