# == Class: awscli::deps
#
# This module manages awscli dependencies and should *not* be called directly.
#
# @param proxy
#   Proxy used when configuring dependencies.
#   Default: undef
#
# === Authors
#
# Justin Downing <justin@downing.us>
#
# === Copyright
#
# Copyright 2014 Justin Downing
#
class awscli::deps (
  Optional[String] $proxy = $awscli::params::proxy,
) inherits awscli::params {
  case $facts['os']['family'] {
    'Debian': {
      contain awscli::deps::debian
    }
    'RedHat': {
      class { 'awscli::deps::redhat':
        proxy => $proxy,
      }
      contain awscli::deps::redhat
    }
    'Darwin': {
      contain awscli::deps::osx
    }
    default:  { fail("The awscli module does not support ${facts['os']['family']}") }
  }
}
