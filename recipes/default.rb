#
# Cookbook Name:: beachhead-cookbook
# Recipe:: default
#

### Create eucalyptus user
beachhead_user = node['beachhead']["user"]
beachhead_group = node['beachhead']["group"]

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