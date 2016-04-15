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

    it 'installs unzip' do
      expect(chef_run).to install_package('unzip')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
