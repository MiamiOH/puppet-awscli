# == Class: awscli::params
#
# This class manages awscli parameters depending on the platform and
# should *not* be called directly.
#
class awscli::params {
  $proxy = undef
  $install_options = undef

  case $facts['os']['family'] {
    'Debian': {
      $pkg_dev      = 'python-dev'
      $pkg_pip      = 'python-pip'
      $pkg_provider = 'pip'
    }
    'RedHat': {
      case $facts['os']['name'] {
        'Amazon': {
          $pkg_dev      = 'python27-devel'
          $pkg_pip      = 'python-pip'
          $pkg_provider = 'pip'
        }
        'Rocky': {
          $pkg_dev      = 'python36-devel'
          $pkg_pip      = 'python3-pip'
          $pkg_provider = 'dnf'
        }
        default: {
          case $facts['os']['release']['major'] {
            '7': {
              $pkg_pip      = 'python2-pip'
              $pkg_dev      = 'python-devel'
              $pkg_provider = 'pip'
            }
            '8': {
              $pkg_dev      = 'python36-devel'
              $pkg_pip      = 'python3-pip'
              $pkg_provider = 'pip3'
            }
            default: {
              $pkg_pip      = 'python-pip'
              $pkg_dev      = 'python-devel'
              $pkg_provider = 'pip'
            }
          }
        }
      }
    }
    'Darwin': {
      $pkg_dev = 'python'
      $pkg_pip = 'brew-pip'
    }
    default:  { fail("The awscli module does not support ${facts['os']['family']}") }
  }
}
