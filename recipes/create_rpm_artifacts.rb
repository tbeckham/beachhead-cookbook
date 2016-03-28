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

# Iterate over rpm hash where key is the RPM's name and
# value is either true, false, or a version string.
rpms = []
rpm_hash.each do |pkgname, install|
  Chef::Log.info "RPM INFO:#{pkgname} ---> #{install}"
  if install.is_a?(Boolean) or install.nil?
    # if the value is 'false' then this RPM is flagged to not download
    if not install
      next
    end
    # Add this RPM to list to be downloaded
    rpms.insert(-1, pkgname)
  elsif install.is_a?(String)
      # Treat the string as a version and append to the package name
      rpms.insert(-1, "#{pkgname}-#{install}")
  end
end

# download rpms into the sandbox dir
package rpms do
  action :install
  options :"--nogpgcheck --downloadonly --downloaddir #{sandbox_dir}"
end


######################################################################################################################
# Create python virtual env to include in dependency archive
######################################################################################################################

