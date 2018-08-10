name             'dcos'
maintainer       'Chef Software, Inc.'
maintainer_email 'partnereng@chef.io'
license          'Apache-2.0'
description      'Installs/Configures Mesosphere DC/OS'
long_description 'Installs/Configures Mesosphere DC/OS'
version          '2.0.1'

source_url 'https://github.com/chef-partners/dcos-cookbook' if
  respond_to?(:source_url)
issues_url 'https://github.com/chef-partners/dcos-cookbook/issues' if
  respond_to?(:issues_url)
chef_version '>= 12.10' if
  respond_to?(:chef_version)

%w(
  centos
  oracle
  redhat
  scientific
).each do |distro|
  supports distro
end

depends 'docker', '~> 4.4'
depends 'selinux', '~> 2.1'
