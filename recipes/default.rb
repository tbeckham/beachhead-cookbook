#
# Cookbook Name:: beachhead-cookbook
# Recipe:: default
#

### Create eucalyptus user
beachhead_user = node['beachhead']["user"]
beachhead_group = node['beachhead']["group"]
sandbox_dir = node['beachhead']['dependency_sandbox_dir']
archive_name = node['beachhead']['dependency_archive_name']
archive_path = File.join(sandbox_dir, archive_name)


user beachhead_user do
  supports :manage_home => true
  comment "Eucalyptus BeachHead User"
  home "/home/#{beachhead_user}"
  shell "/bin/bash"
end

group beachhead_group do
  action :modify
  members beachhead_user
  append true
end

# Create the dir to download/create dependency artifacts
directory sandbox_dir do
  owner beachhead_user
  group beachhead_group
  mode '0755'
  action :create
end
