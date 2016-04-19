#
# Cookbook Name:: dcos
# Spec:: default
#

require 'spec_helper'

describe 'dcos::default' do
  context 'Default behavior, assume eth0' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['network']['interfaces']['eth0']['addresses'] =
          {
            '1.2.3.4' =>
              {
                'family' => 'inet',
                'netmask' => '255.255.255.0',
                'broadcast' => '192.168.1.255'
              }
          }
      end.converge(described_recipe)
    end

    it 'stops service firewalld' do
      expect(chef_run).to stop_service('firewalld')
    end

    it 'disables service firewalld' do
      expect(chef_run).to disable_service('firewalld')
    end

    it 'installs unzip' do
      expect(chef_run).to install_package('unzip')
    end

    it 'installs ipset' do
      expect(chef_run).to install_package('ipset')
    end

    it 'creates group[nogroup]' do
      expect(chef_run).to create_group('nogroup')
    end

    # docker_service
    # remote_file

    it 'creates genconf directory' do
      expect(chef_run).to create_directory('/root/genconf').with(mode: '0755')
    end

    # template
    # include_recipe

    it 'dcos-genconf' do
      expect(chef_run).to run_execute('dcos-genconf').with(user: 'root')
    end

    it 'sets permissions on dcos_install.sh' do
      expect(chef_run).to create_file('/root/genconf/serve/dcos_install.sh').with(mode: '0755')
    end

    it 'dcos_install' do
      expect(chef_run).to run_execute('dcos-genconf').with(user: 'root')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
