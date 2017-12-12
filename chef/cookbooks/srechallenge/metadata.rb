name 'srechallenge'
maintainer 'Arthur Shvarts'
maintainer_email 'ashvarts@gmail.com'
license 'all_rights'
description 'Installs/Configures web server per srechallenge'
long_description 'Installs/Configures srechallenge'
version '0.1.0'

# If you upload to Supermarket you should set this so your cookbook
# gets a `View Issues` link
# issues_url 'https://github.com/<insert_org_here>/srechallenge/issues' if respond_to?(:issues_url)

# If you upload to Supermarket you should set this so your cookbook
# gets a `View Source` link
# source_url 'https://github.com/<insert_org_here>/srechallenge' if respond_to?(:source_url)

depends 'chef_nginx'
depends 'firewall'
depends 'iptables'
