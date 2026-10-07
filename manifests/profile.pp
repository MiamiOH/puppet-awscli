# == Define: awscli::profile
#
# Configures an aws-cli profile
#
# === Parameters
#
# @param ensure
#   Control whether the profile should be present or not.
#   Default: present
#
# @param user
#   The user for whom the profile will be installed.
#   Default: root
#
# @param group
#   The group for whom the profile will be installed.
#   Default: undef
#
# @param homedir
#   The home directory where the config and credentials will be placed.
#   Default: determined from the user and operating system.
#
# @param aws_access_key_id
#   The AWS access key ID for this profile. If not specified, aws-cli can
#   use IAM roles to authenticate.
#
# @param aws_secret_access_key
#   The AWS secret access key for this profile. If not specified, aws-cli can
#   use IAM roles to authenticate.
#
# @param role_arn
#   The ARN for the role to use in this profile. The source_profile must
#   be supplied when role_arn is specified.
#
# @param source_profile
#   The profile to use for credentials to assume the specified role.
#
# @param role_session_name
#   An identifier for the assumed role session.
#
# @param aws_region
#   The AWS region for this profile.
#   Default: us-east-1
#
# @param profile_name
#   The name of the AWS profile.
#   Default: default
#
# @param output
#   The output format used for this profile.
#   Default: json
#
# === Example
#
# awscli::profile { 'tsmith-awscli':
#   user                  => 'tsmith',
#   aws_access_key_id     => 'access_key',
#   aws_secret_access_key => 'secret_key',
#   aws_region            => 'us-west-2',
#   role_arn              => 'arn:aws:iam::123456789012:role/MyRole',
#   source_profile        => 'user',
#   role_session_name     => 'mysession',
#   profile_name          => 'default',
#   output                => 'text',
# }
#
define awscli::profile (
  String $ensure = 'present',
  String $user = 'root',
  Optional[String] $group = undef,
  Optional[String] $homedir = undef,
  Optional[String] $aws_access_key_id = undef,
  Optional[String] $aws_secret_access_key = undef,
  Optional[String] $role_arn = undef,
  Optional[String] $source_profile = undef,
  Optional[String] $role_session_name = undef,
  String $aws_region = 'us-east-1',
  String $profile_name = 'default',
  String $output = 'json',
) {
  if $aws_access_key_id == undef and $aws_secret_access_key == undef {
    info ('AWS keys for awscli::profile. Your will need IAM roles configured.')
    $skip_credentials = true
  } else {
    $skip_credentials = false
  }

  if $homedir {
    $homedir_real = $homedir
  } else {
    if $user != 'root' {
      $homedir_real = $facts['os']['family']? {
        'Darwin' => "/Users/${user}",
        default  => "/home/${user}"
      }
    } else {
      $homedir_real = '/root'
    }
  }

  if ($group == undef) {
    if $user != 'root' {
      $group_real = $facts['os']['family']? {
        'Darwin' => 'staff',
        default  => $user
      }
    } else {
      $group_real = 'root'
    }
  } else {
    $group_real = $group
  }

  # ensure $homedir/.aws is available
  if !defined(File["${homedir_real}/.aws"]) {
    file { "${homedir_real}/.aws":
      ensure => 'directory',
      owner  => $user,
      group  => $group_real,
      mode   => '0700',
    }
  }

  # setup credentials
  if ! $skip_credentials {
    if !defined(Concat["${homedir_real}/.aws/credentials"]) {
      concat { "${homedir_real}/.aws/credentials":
        ensure    => 'present',
        owner     => $user,
        group     => $group_real,
        mode      => '0600',
        show_diff => false,
        require   => File["${homedir_real}/.aws"],
      }
    }

    if ( $ensure == 'present' ) {
      concat::fragment { "${title}-credentials":
        target  => "${homedir_real}/.aws/credentials",
        content => template('awscli/credentials_concat.erb'),
      }
    }
  }

  # setup config
  if !defined(Concat["${homedir_real}/.aws/config"]) {
    concat { "${homedir_real}/.aws/config":
      ensure  => 'present',
      owner   => $user,
      group   => $group_real,
      mode    => '0600',
      require => File["${homedir_real}/.aws"],
    }
  }

  if ( $ensure == 'present' ) {
    concat::fragment { "${title}-config":
      target  => "${homedir_real}/.aws/config",
      content => template('awscli/config_concat.erb'),
    }
  }
}
