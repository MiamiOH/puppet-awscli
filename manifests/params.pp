# == Class: awscli::params
#
# This class manages awscli parameters depending on the platform and
# should *not* be called directly.
#
# == Class: awscli::params
#
# This class provides backwards-compatible parameter defaults using Hiera.
#
# Values are expected to be defined in Hiera as:
#
#   awscli::pkg_dev
#   awscli::pkg_pip
#   awscli::provider
#   awscli::proxy
#   awscli::install_options
#
class awscli::params {
  $proxy = lookup('awscli::proxy', {
      'default_value' => undef,
      'value_type'    => Optional[String],
  })

  $install_options = lookup('awscli::install_options', {
      'default_value' => undef,
      'value_type'    => Optional[Array[String]],
  })

  $pkg_dev = lookup('awscli::pkg_dev', {
      'value_type' => String,
  })

  $pkg_pip = lookup('awscli::pkg_pip', {
      'value_type' => String,
  })

  $pkg_provider = lookup('awscli::provider', {
      'value_type' => String,
  })
}
