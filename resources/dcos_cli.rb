#
# Cookbook Name:: dcos
# Resource:: dcos_cli
#
# Copyright 2018, Chris Gianelloni
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

resource_name :dcos_cli

# standard attributes for this resource
property :command, String, name_property: true
property :cluster_uri, String, required: false, default: 'http://leader.mesos'
property :cli_path, String, default '/usr/local/bin/dcos'
property :ssl_verify, [true, false], default: false

# copied from execute resource
property :cwd, String
property :environment, Hash, default: {}
property :user, [String, Integer]
property :sensitive, [true, false], default: false

# optional authentication
property :username, String, required: false, default: nil
property :password, String, sensitive: true, required: false, default: nil

action :run do
  # set some empty variables
  run_env = {}
  user_pass = ''
  ssl_verify = ''

  # set some other variables
  cli = new_resource.cli_path

  if new_resource.username && new_resource.password
    run_env = new_resource.environment.merge({'DCOS_PASSWORD': new_resource.password})
    user_pass = "--username=#{new_resource.username} --password-env=DCOS_PASSWORD"
  end

  ### TODO: make this support older DC/OS versions, OSS versions, etc.
  execute 'dcos-cluster-setup' do
    command "#{cli} cluster setup #{new_resource.cluster_uri} #{ssl_verify} #{user_pass}"
    environment run_env
    sensitive true
    only_if "#{cli} cluster --info"
  end

  # assume that we're authenticated, or don't need authentication
  execute 'dcos-cli' do
    command "#{cli} #{new_resource.command}"
    cwd new_resource.cwd
    environment new_resource.environment
    sensitive new_resource.sensitive
    user new_resource.user
  end
end
