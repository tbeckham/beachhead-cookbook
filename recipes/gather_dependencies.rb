#
# Cookbook Name:: beachhead-cookbook
# Recipe:: gather_dependencies
#
# Gather Eucalyptus deployment dependencies

include_recipe "beachead::default"

beachhead_user = node['beachhead']["user"]
beachhead_group = node['beachhead']["group"]
sandbox_dir = node['beachhead']['dependency_sandbox_dir']
archive_name = node['beachhead']['dependency_archive_name']
archive_path = File.join(sandbox_dir, archive_name)


######################################################################################################################
# Create a list of packages to download into the sandbox directory
######################################################################################################################
rpm_hash = node['beachhead']['euca_rpms']
rpm_hash.merge(node['beachhead']['system_rpms'])
rpm_hash.merge(node['beachhead']['euca_enterprise_rpms'])
rpm_hash.merge(node['beachhead']['euca_backend_rpms'])
rpm_hash.merge(node['beachhead']['extra_rpms'])

rpms = []
rpm_hash.each do |key, install|
  puts "#{key} ---> #{install}"
  if install.is_a?(Boolean)
    if not install
      next
    end
  elsif install.is_a?(String)
      rpms.insert(-1, "#{key}-#{install}")
  end
end

directory sandbox_dir do
  owner beachhead_user
  group beachhead_group
  mode '0755'
  action :create
end

package rpms do
  action :install
  options :"--nogpgcheck --downloadonly --downloaddir #{sandbox_dir}"
end

######################################################################################################################
# Create python virtual env to include in dependency archive
######################################################################################################################

