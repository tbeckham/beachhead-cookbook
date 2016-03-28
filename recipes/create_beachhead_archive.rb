
# Cookbook Name:: beachhead-cookbook
# Recipe:: create_beachhead_archive
# Used to create the virtual env for deployment and testing tools

include_recipe "beachead::default"
include_recipe "create_python_artifacts"
include_recipe "create_rpm_artifacts"

######################################################################################################################
# Creates a zipped tar archive containing the Eucalyptus Beach Head dependencies used to deploy and manage Eucalyptus
######################################################################################################################

sandbox_dir = node['beachhead']['dependency_sandbox_dir']
archive_name = node['beachhead']['dependency_archive_name']
archive_path = File.join(sandbox_dir, archive_name)

yum_package "tar" do
  action :install
end

execute 'Create Tar File' do
  command "tar -cvzf #{archive_path} #{sandbox_dir}"
end
