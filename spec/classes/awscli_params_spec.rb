# frozen_string_literal: true

require 'spec_helper'

describe 'awscli::params', type: :class do
  context 'on Debian' do
    let(:facts) do
      {
        os: {
          family: 'Debian',
        },
      }
    end

    it { is_expected.to compile }
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

    it { is_expected.to compile }
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

    it { is_expected.to compile }
  end

  context 'on Amazon Linux' do
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

    it { is_expected.to compile }
  end

  context 'on Rocky Linux' do
    let(:facts) do
      {
        os: {
          family: 'RedHat',
          name: 'Rocky',
          release: {
            major: '9',
          },
        },
      }
    end

    it { is_expected.to compile }
  end

  context 'on Darwin' do
    let(:facts) do
      {
        os: {
          family: 'Darwin',
        },
      }
    end

    it { is_expected.to compile }
  end

  context 'on an unsupported OS' do
    let(:facts) do
      {
        os: {
          family: 'FreeBSD',
        },
      }
    end

    it 'fails with an unsupported OS error' do
      expect { catalogue }.to raise_error(
        Puppet::Error,
        %r{The awscli module does not support FreeBSD},
      )
    end
  end
end
