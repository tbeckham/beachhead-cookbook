#
# Cookbook Name:: beachhead-cookbook
# Recipe:: gather_dependencies
#
# Gather Eucalyptus deployment dependencies

include_recipe "beachhead-cookbook::default"

######################################################################################################################
# Downloads all the specified RPMs into the provided sandbox directory for later including in the
# beachhead archive.
######################################################################################################################

beachhead_user = node['beachhead']["user"]
beachhead_group = node['beachhead']["group"]
sandbox_dir = File.join(node['beachhead']['dependency_sandbox_dir'], 'rpms')
archive_name = node['beachhead']['dependency_archive_name']
archive_path = File.join(sandbox_dir, archive_name)
yum_repo_hash = node['beachhead']['repos']

######################################################################################################################
## Add the yum repos 
#######################################################################################################################

if node['beachhead']['add_epel']
  package 'epel-release' do
    action :install
  end
end

yum_repo_hash.each do |reponame, repo_url|
  yum_repository reponame do
    action :create
    description "#{reponame} Package Repo"
    url repo_url
    gpgcheck false
    metadata_expire "1"
  end
end

######################################################################################################################
# Create a list of packages to download into the sandbox directory
######################################################################################################################
rpm_hash = node['beachhead']['euca_rpms']
rpm_hash.merge(node['beachhead']['system_rpms'])
rpm_hash.merge(node['beachhead']['euca_enterprise_rpms'])
rpm_hash.merge(node['beachhead']['euca_backend_rpms'])
rpm_hash.merge(node['beachhead']['extra_rpms'])
yum_options = "--nogpgcheck --downloadonly --downloaddir #{sandbox_dir}"

# Iterate over rpm hash where key is the RPM's name and
# value is either true, false, or a version string.
rpms = []
rpm_hash.each do |pkgname, install|
  Chef::Log.info "RPM INFO:#{pkgname} ---> #{install}"
  if [true, false].include?(install) or install.nil?
    # if the value is 'false' then this RPM is flagged to not download
    if not install
      next
    end
    # Add this RPM to list to be downloaded
  elsif install.is_a?(String)
    # Treat the string as a version and append to the package name
    pkgname = "#{pkgname} #{install}"
  end
  package pkgname do
    action :install
    options yum_options
  end
end

# download rpms into the sandbox dir
#package rpms do
#  action :install
#end

######################################################################################################################
# Create python virtual env to include in dependency archive
######################################################################################################################

