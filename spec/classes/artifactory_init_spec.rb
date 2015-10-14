require 'spec_helper'

describe 'artifactory', :type => :class do
  context 'On a RedHat OS with no package name specified' do
    let(:facts) do
      {
        :concat_basedir         => '/var/lib/puppet/concat',
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '7'
      }
    end

    it { should create_class('artifactory') }
    it { should contain_class('::artifactory::install') }
    it { should contain_class('::artifactory::config') }
    it { should contain_class('::artifactory::service') }
  end

  context 'On an unknown OS with no package name specified' do
    let :facts do
      {
        :osfamily => 'Darwin'
      }
    end

    it { expect { should raise_error(Puppet::Error) } }
  end
end
