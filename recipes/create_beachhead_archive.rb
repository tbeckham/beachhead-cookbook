
# Cookbook Name:: beachhead-cookbook
# Recipe:: create_beachhead_archive
# Used to create the virtual env for deployment and testing tools

include_recipe "beachhead-cookbook::default"
include_recipe "beachhead-cookbook::create_python_artifacts"
include_recipe "beachhead-cookbook::create_rpm_artifacts"

######################################################################################################################
# Creates a zipped tar archive containing the Eucalyptus Beach Head dependencies used to deploy and manage Eucalyptus
######################################################################################################################

sandbox_dir = node['beachhead']['dependency_sandbox_dir']
archive_name = node['beachhead']['dependency_archive_name']
archive_path = File.join(sandbox_dir, archive_name)

yum_package "tar" do
  action :install
end

Chef::Log.info "Attempting to create tarball of dependencies: tar -cvzf #{archive_path} #{sandbox_dir}"
execute 'Create Tar File' do
  command "cd #{sandbox_dir} && tar -cvzf #{archive_path} --exclude #{archive_name} *"
end

