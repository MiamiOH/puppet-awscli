# == Class: awscli::params
#
# This class manages awscli parameters depending on the platform and
# should *not* be called directly.
#
class awscli::params {

  $proxy = undef
  $install_options = undef

  case $::os['family'] {
    'Debian': {
      $pkg_dev = 'python-dev'
      $pkg_pip = 'python-pip'
    }
    'RedHat': {
      case $::os['name'] {
        'Amazon': {
          $pkg_dev = 'python27-devel'
          $pkg_pip = 'python-pip'
        }
        default: {
          case $::os['release']['major'] {
            '7': {
              $pkg_pip = 'python2-pip'
              $pkg_dev = 'python-devel'
            }
            '8': {
              $pkg_dev = 'python36-devel'
              $pkg_pip = 'python3-pip'
            }
            default: {
              $pkg_pip = 'python-pip'
              $pkg_dev = 'python-devel'
            }
          }
        }
      }
    }
    'Darwin': {
      $pkg_dev = 'python'
      $pkg_pip = 'brew-pip'
    }
    default:  { fail("The awscli module does not support ${::os['family']}") }
  }
}
