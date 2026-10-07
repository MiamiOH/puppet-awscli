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
      )
    end
  end

  context 'on Darwin' do
    let(:facts) do
      {
        os: {
          family: 'Darwin',
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
  end
end
