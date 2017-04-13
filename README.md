[![Build Status](https://travis-ci.org/chef-partners/dcos-cookbook.svg?branch=master)](https://travis-ci.org/chef-partners/dcos-cookbook)

Description
===========

Manage deployment and configuration of underlying Mesosphere DCOS installation.

Requirements
------------

Only Red Hat or CentOS 7.x are currently supported.

Usage
==========

The behavior of this cookbook is managed by attributes documented in the [attributes file](attributes/default.rb). The `node['dcos']['dcos_role']` attribute controls the DCOS role to apply to the node (default is `master`). The `node['dcos']['master_list']` must be set to specify the list of DCOS master node IPv4 addresses to connect at startup (this must be an odd number of masters).

If you would like to have the stable channel, please flip the `node['dcos']['dcos_earlyaccess']` to `false`.

Roles
----------

You can create a Chef Role and apply it to nodes as necessary to specify `master`, `slave` and `slave_public` as appropriate. Any additional configuration should probably be set as override attributes in an Environment to ensure all nodes receive those global settings.

### Example Role dcos_master.rb ###
````ruby
name "dcos_master"
description "DCOS master role"
run_list "recipe[dcos]"
default_attributes "dcos" => {
    "dcos_role" => "master"
    "master_list" => [ "10.0.2.10" ]
}
````

### Example Role dcos_slave.rb ###
````ruby
name "dcos_slave"
description "DCOS slave role"
run_list "recipe[dcos]"
default_attributes "dcos" => {
    "dcos_role" => "slave"
    "master_list" => [ "10.0.2.10" ]
}
````

Recipe
=======

default
-------

Installs the prerequisites for the Mesosphere DCOS installation, including packages, groups and Docker with OverlayFS enabled. It then downloads and runs the installation package with the settings configured by the node's attributes.

Testing
=======

ChefSpec
--------
There is basic coverage for the default recipe.

InSpec
------
TBD

Test Kitchen
------------
The included [.kitchen.yml](.kitchen.yml) runs the default master deployment in a generic fashion. The included [.kitchen.local.yml.example](.kitchen.local.yml.example) shows alternate settings for running multi-master with slaves on GCE (you will have to rename and update accordingly).

License and Author
==================

Author:: Matt Ray (<matt@chef.io>)

Copyright 2016 Chef Software, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
