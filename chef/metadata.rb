name 'lo'
maintainer 'The Authors'
maintainer_email 'you@example.com'
license 'All Rights Reserved'
description 'Installs/Configures lo'
version '0.1.0'
chef_version '>= 15.0'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/lo/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/lo'
depends 'docker-ce', '~> 0.11.0'
depends 'docker_compose', '~> 0.1.1'
depends 'zipfile', '~> 0.2.0'
depends 'docker'