#
# Cookbook Name:: dcos
# Spec:: default
#

require 'spec_helper'

describe 'dcos::default' do
  context 'Default behavior, assume eth0' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '7.3.1611') do |node|
        node.override['network']['interfaces']['eth0']['addresses'] =
          {
            '1.2.3.4' =>
              {
                'family' => 'inet',
                'netmask' => '255.255.255.0',
                'broadcast' => '192.168.1.255',
              },
          }
        stub_command(/ping -c1 /).and_return(false)
      end.converge(described_recipe)
    end

    it 'sets SELinux to permissive' do
      expect(chef_run).to permissive_selinux_state('SELinux Permissive')
    end

    %w(
      firewalld
      rsyslog
    ).each do |svc|
      it "stops and disables #{svc}" do
        expect(chef_run).to stop_service(svc)
        expect(chef_run).to disable_service(svc)
      end
    end

    it 'installs %w(curl ipset tar unzip xz)' do
      expect(chef_run).to install_package(%w(curl ipset tar unzip xz))
    end

    it 'creates group[nogroup]' do
      expect(chef_run).to create_group('nogroup')
    end

    it 'creates docker service' do
      expect(chef_run).to create_docker_service('default')
    end

    it 'creates remote_file[dcos_generate_config.sh]' do
      expect(chef_run).to create_remote_file('/usr/src/dcos/dcos_generate_config.sh').with(mode: '0755')
    end

    it 'creates directory[genconf]' do
      expect(chef_run).to create_directory('/usr/src/dcos/genconf').with(mode: '0755')
    end

    it 'creates template[config.yaml]' do
      expect(chef_run).to create_template('/usr/src/dcos/genconf/config.yaml')
    end

    it 'creates /usr/src/dcos/genconf/ip-detect from template' do
      expect(chef_run).to create_template('/usr/src/dcos/genconf/ip-detect')
    end

    it 'creates /usr/src/dcos/genconf/ip-detect-public from file' do
      expect(chef_run).to create_cookbook_file('/usr/src/dcos/genconf/ip-detect-public')
    end

    it 'executes[dcos-genconf]' do
      expect(chef_run).to run_execute('dcos-genconf').with(user: 'root')
    end

    it 'ensures /usr/src/dcos/genconf/serve/dcos_install.sh is executable' do
      expect(chef_run).to create_file('/usr/src/dcos/genconf/serve/dcos_install.sh').with(mode: '0755')
    end

    it 'executes[dcos_install]' do
      expect(chef_run).to run_execute('dcos_install').with(user: 'root')
    end

    %w(
      mesos
      marathon
    ).each do |svc|
      it "executes[check-#{svc}-up]" do
        expect(chef_run).to run_execute("check-#{svc}-up")
      end
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
