#
# Cookbook Name:: dcos
# Recipe:: default
#
# Copyright 2016, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Prereqs
include_recipe 'selinux::permissive'

%w(
  firewalld
  rsyslog
).each do |svc|
  service svc do
    action %i(stop disable)
  end
end

package %w(
  curl
  ipset
  tar
  unzip
  xz
)

group 'nogroup'

include_recipe 'chef-yum-docker' if node['dcos']['docker_version']

# Install docker with overlayfs
docker_service 'default' do
  storage_driver node['dcos']['docker_storage_driver']
  version node['dcos']['docker_version'] if node['dcos']['docker_version']
  install_method 'package' if node['dcos']['docker_version']
  action %i(create start)
  only_if { node['dcos']['manage_docker'] }
end

directory '/usr/src/dcos/genconf' do
  mode '0755'
  recursive true
end

template '/usr/src/dcos/genconf/config.yaml' do
  source 'config.yaml.erb'
  variables config: node['dcos']['config']
end

remote_file '/usr/src/dcos/dcos_generate_config.sh' do
  source dcos_generate_config_url
  mode '0755'
end

# generate the genconf/ip-detect script
include_recipe 'dcos::_ip-detect'

execute 'dcos-genconf' do
  command '/usr/src/dcos/dcos_generate_config.sh --genconf'
  user 'root'
  cwd '/usr/src/dcos'
  creates '/usr/src/dcos/genconf/cluster_packages.json'
end

file '/usr/src/dcos/genconf/serve/dcos_install.sh' do
  mode '0755'
end

execute 'dcos_install' do
  command "/usr/src/dcos/genconf/serve/dcos_install.sh #{node['dcos']['dcos_role']}"
  creates '/opt/mesosphere/environment'
  user 'root'
  cwd '/usr/src/dcos'
  action :run
end

# Poll for leader.mesos to ensure we're up before finishing converge
execute 'check-mesos-up' do
  command 'ping -c1 leader.mesos'
  retry_delay 1
  retries node['dcos']['leader_check_retries']
  action :run
  not_if 'ping -c1 leader.mesos'
end

execute 'check-marathon-up' do
  command 'ping -c1 marathon.mesos'
  retry_delay 1
  retries node['dcos']['leader_check_retries']
  action :run
  not_if 'ping -c1 marathon.mesos'
end
