#
# Cookbook:: lo
# Recipe:: nginx
#
# Copyright:: 2020, The Authors, All Rights Reserved.
file '/tmp/lotest.txt' do
    content 'This is a test to create an new file with content with chef'
    action :create
end
apt_update 'Update apt repo' do
    ignore_failure true
    action :update
end

apt_package 'nginx' do
    action :install
end