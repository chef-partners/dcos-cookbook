name 'dcos'
maintainer 'Chef Software, Inc.'
maintainer_email 'partnereng@chef.io'
license 'Apache-2.0'
description 'Installs/Configures Mesosphere'
long_description 'Installs/Configures Mesosphere'
version '0.3.0'

source_url 'https://github.com/chef-partners/dcos-cookbook' if
  respond_to?(:source_url)
issues_url 'https://github.com/chef-partners/dcos-cookbook/issues' if
  respond_to?(:issues_url)
chef_version '>= 11' if
  respond_to?(:chef_version)

supports 'centos'
supports 'oracle'
supports 'redhat'
supports 'scientific'

depends 'docker', '~> 2.0'
depends 'selinux', '~> 0.9.0'
