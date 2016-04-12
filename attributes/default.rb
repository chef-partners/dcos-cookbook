#
# Author:: Matt Ray <matt@chef.io>
# Cookbook Name:: mesosphere
#
# Copyright 2016 Chef Software, Inc
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

default['mesosphere']['dcos_version'] = 'stable'
default['mesosphere']['dcos_role'] = 'master' # options are master, slave or slave_public

default['mesosphere']['cluster_name'] = 'DCOS'
default['mesosphere']['master_discovery'] = 'static'
default['mesosphere']['exhibitor_storage_backend'] = 'static'
default['mesosphere']['bootstrap_url'] = 'file:///opt/dcos_install_tmp'

# ipv4 only, must be odd number 1-9
default['mesosphere']['master_list'] = []
# upstream DNS for MesosDNS
default['mesosphere']['resolvers'] = ['8.8.8.8', '8.8.4.4']

# All Possible Parameters / Attrbutes with logical defaults and their dependencies if any

# Config.yaml Parameters
# EE Only
# $superuser_username = 'admin'
# $superuser_password_hash = undef

# Exhibitor Storage Backend Dependencies
# $exhibitor_storage_backend:'zookeeper':
# Bootstrap exhibitor using another zk cluster for shared file data
# $exhibitor_zk_hosts = undef # Comma list of $HOST:2181, $HOST:2181...
# $exhibitor_zk_path = '/dcos'

# $exhibitor_storage_backend: 'shared_filesystem'
# This parameter specifies the absolute path to the folder
# that Exhibitor uses to coordinate its configuration. This should
# be a directory inside of a Network File System (NFS) mount. For
# example, if every master has /fserv mounted via NFS, set as
# exhibitor_fs_config_dir: /fserv/dcos-exhibitor.
# $exhibitor_fs_config_dir = undef

# exhibitor_storage_backend:'aws_s3'
# $aws_access_key_id = undef
# $aws_region = undef
# $aws_secret_access_key = undef
# $s3_bucket = undef
# # This parameter specifies S3 prefix to be used within your
# # S3 bucket to be used by Exhibito
# $s3_prefix = undef

# # Master Discovery Dependencies
# # master_discovery:'static'
# $master_list = $::master_list

# master_discovery: 'vrrp'
# This parameter specifies the virtual router ID of the Keepalived cluster.
# You must use the same virtual router ID across your cluster.
# $keepalived_router_id = undef
# # This parameter specifies the interface that Keepalived uses.
# $keepalived_interface = undef
# # If you've set your auth_type to PASS, this parameter specifies the password
# # that you set for auth_pass in your Keepalived configuration file.
# $keepalived_pass = undef
# # This parameter specifies the VIP in use by your Keepalived cluster.
# $keepalived_virtual_ipaddress = undef
