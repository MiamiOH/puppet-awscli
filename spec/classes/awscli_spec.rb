# frozen_string_literal: true

require 'spec_helper'

Puppet::Type.type(:package).provide(
  :homebrew,
  parent: Puppet::Type.type(:package).provider(:generic),
) do
end

describe 'awscli', type: :class do
  context 'on Debian' do
    let(:facts) do
      {
        os: {
          family: 'Debian',
          name: 'Debian',
          release: {
            major: '12',
          },
        },
      }
    end

    let(:params) do
      {
        manage_epel: false,
        install_pkgdeps: true,
        install_pip: true,
      }
    end

    it { is_expected.to compile }

    it { is_expected.to contain_class('awscli::deps') }
    it { is_expected.to contain_class('awscli::deps::debian') }

    it do
      is_expected.to contain_package('python-dev').with(
        ensure: 'installed',
      )
    end

    it do
      is_expected.to contain_package('python-pip').with(
        ensure: 'installed',
      )
    end

    it do
      is_expected.to contain_package('awscli').with(
        ensure: 'present',
        provider: 'pip',
        install_options: nil,
      )
    end
  end

  context 'on RedHat 7' do
    let(:facts) do
      {
        os: {
          family: 'RedHat',
          name: 'CentOS',
          release: {
            major: '7',
          },
        },
      }
    end

    let(:params) do
      {
        manage_epel: false,
        install_pkgdeps: true,
        install_pip: true,
      }
    end

    it { is_expected.to compile }

    it { is_expected.to contain_class('awscli::deps') }
    it { is_expected.to contain_class('awscli::deps::redhat') }

    it do
      is_expected.to contain_package('python-devel').with(
        ensure: 'installed',
      )
    end

    it do
      is_expected.to contain_package('python2-pip').with(
        ensure: 'installed',
      )
    end

    it do
      is_expected.to contain_package('awscli').with(
        ensure: 'present',
        provider: 'pip',
        install_options: nil,
      )
    end
  end

  context 'on RedHat 8' do
    let(:facts) do
      {
        os: {
          family: 'RedHat',
          name: 'CentOS',
          release: {
            major: '8',
          },
        },
      }
    end

    let(:params) do
      {
        manage_epel: false,
        install_pkgdeps: true,
        install_pip: true,
      }
    end

    it { is_expected.to compile }

    it { is_expected.to contain_class('awscli::deps') }
    it { is_expected.to contain_class('awscli::deps::redhat') }

    it do
      is_expected.to contain_package('python36-devel').with(
        ensure: 'installed',
      )
    end

    it do
      is_expected.to contain_package('python3-pip').with(
        ensure: 'installed',
      )
    end

    it do
      is_expected.to contain_package('awscli').with(
        ensure: 'present',
        provider: 'pip3',
        install_options: nil,
      )
    end
  end

  context 'on Amazon Linux 2' do
    let(:facts) do
      {
        os: {
          family: 'RedHat',
          name: 'Amazon',
          release: {
            major: '2',
          },
        },
      }
    end

    let(:params) do
      {
        manage_epel: false,
        install_pkgdeps: true,
        install_pip: true,
      }
    end

    it { is_expected.to compile }

    it { is_expected.to contain_class('awscli::deps') }
    it { is_expected.to contain_class('awscli::deps::redhat') }

    it do
      is_expected.to contain_package('python27-devel').with(
        ensure: 'installed',
      )
    end

    it do
      is_expected.to contain_package('python-pip').with(
        ensure: 'installed',
      )
    end

    it do
      is_expected.to contain_package('awscli').with(
        ensure: 'present',
        provider: 'pip',
        install_options: nil,
      )
    end
  end

  context 'on Darwin' do
    let(:facts) do
      {
        os: {
          family: 'Darwin',
          name: 'Darwin',
        },
      }
    end

    let(:params) do
      {
        install_pkgdeps: true,
        install_pip: true,
      }
    end

    it { is_expected.to compile }

    it { is_expected.to contain_class('awscli::deps') }
    it { is_expected.to contain_class('awscli::deps::osx') }

    it do
      is_expected.to contain_package('python').with(
        ensure: 'installed',
        provider: 'homebrew',
      )
    end

    it do
      is_expected.to contain_package('brew-pip').with(
        ensure: 'installed',
        provider: 'homebrew',
      )
    end

    it do
      is_expected.to contain_package('awscli').with(
        ensure: 'present',
        provider: 'pip',
        install_options: nil,
      )
    end
  end

  context 'with custom install options' do
    let(:facts) do
      {
        os: {
          family: 'RedHat',
          name: 'CentOS',
          release: {
            major: '8',
          },
        },
      }
    end

    let(:params) do
      {
        manage_epel: false,
        install_options: ['--proxy foo'],
      }
    end

    it { is_expected.to compile }

    it do
      is_expected.to contain_package('awscli').with(
        ensure: 'present',
        provider: 'pip3',
        install_options: ['--proxy foo'],
      )
    end
  end

  context 'with package dependencies disabled' do
    let(:facts) do
      {
        os: {
          family: 'RedHat',
          name: 'CentOS',
          release: {
            major: '8',
          },
        },
      }
    end

    let(:params) do
      {
        manage_epel: false,
        install_pkgdeps: false,
        install_pip: false,
      }
    end

    it { is_expected.to compile }

    it { is_expected.to contain_class('awscli::deps') }

    it do
      is_expected.not_to contain_package('python36-devel')
    end

    it do
      is_expected.not_to contain_package('python3-pip')
    end

    it do
      is_expected.to contain_package('awscli').with(
        ensure: 'present',
        provider: 'pip3',
      )
    end
  end
end
