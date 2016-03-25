#
# Cookbook Name:: beachhead-cookbook
# Recipe:: default
#




### Create eucalyptus user
user "eucalyptus" do
  supports :manage_home => true
  comment "Eucalyptus User"
  home "/home/eucalyptus"
  shell "/bin/bash"
end

