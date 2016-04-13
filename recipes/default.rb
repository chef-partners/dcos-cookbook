#
# Cookbook Name:: mesosphere
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
# 1. Install docker with overlayfs
# 2. CentOS7 or greater supported
docker_service 'default' do
   storage_driver 'overlay'
   action [:create, :start]
end

# Pipeline
# 1. Download dcos_generate_config.sh to $HOME
#   - Note this link does not have versioning, so using it will always be the latest DCOS. This URL might change in the future, but for now this cookbook will only install the latest stable release.
remote_file "/root/dcos_generate_config.sh" do
  # source "https://s3.amazonaws.com/downloads.mesosphere.io/dcos/stable/dcos_generate_config.sh"
  source "https://downloads.mesosphere.io/dcos/testing/continuous/dcos_generate_config.sh"
  # owner 'web_admin'
  # group 'web_admin'
  mode '0755'
  # action :create
end

# 2. mkdir $HOME/genconf && touch $HOME/genconf/config.yaml
directory "/root/genconf" do
  # owner 'root'
  # group 'root'
  mode '0755'
  # action :create
end

# 3. The config file several parameters, some parameters have dependencies. The most basic config.yaml looks like this:
template "/root/genconf/config.yaml" do
  source 'config.yaml.erb'
  # owner 'root'
  # group 'root'
  # mode '0644'
  # action :create
end

# 4. Execute --genconf: $HOME/dcos_generate_config.sh --genconf
execute "dcos-genconf" do
  command "/root/dcos_generate_config.sh --genconf"
  cwd "/root"
end

# 5. Execute installation: $HOME/genconf/serve/dcos_install.sh $DCOS_ROLE {master | slave | slave_public}

# This should be enough to get you started, please keep in touch over the next couple of weeks and don't ever hesitate to reach out!
