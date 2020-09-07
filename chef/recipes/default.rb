#
# Cookbook:: lo
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
include_recipe 'docker-ce'
include_recipe 'lo::docker-compose'
include_recipe 'lo::apt-install'
include_recipe 'lo::copy-files'