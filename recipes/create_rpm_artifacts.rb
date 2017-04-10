#
# Cookbook Name:: beachhead-cookbook
# Recipe:: create_rpm_artifacts
#
# Gather Eucalyptus deployment dependencies

include_recipe "beachhead-cookbook::default"

######################################################################################################################
# Downloads all the specified RPMs into the provided sandbox directory for later including in the
# beachhead archive.
######################################################################################################################

beachhead_user = node['beachhead']["user"]
beachhead_group = node['beachhead']["group"]
sandbox_dir = node['beachhead']['dependency_sandbox_dir']
rpm_subdir = File.join(sandbox_dir, node['beachhead']['rpm_subdir'])
yum_repo_hash = node['beachhead']['repos']


directory rpm_subdir do
  owner beachhead_user
  group beachhead_group
  action :create
  recursive true
  not_if { ::File.exist? "#{rpm_subdir}" }
end

######################################################################################################################
## Add the yum repos 
#######################################################################################################################

if node['beachhead']['add_epel']
  package 'epel-release' do
    action :install
    not_if { "rpm -qa | grep epel-release" }
  end
end

username = Mixlib::ShellOut.new("whoami")
username.run_command
name = username.stdout.strip

yumdownloader_all_repos = String.new

yum_repo_hash.each do |reponame, repo_url|
  if !node['beachhead']['alt-yum-config-location']
    yumdownloader_all_repos = "#{yumdownloader_all_repos}" + " -c /etc/yum.repos.d/#{reponame}.repo"
    yum_repository reponame do
      action :create
      description "#{reponame} Package Repo"
      url repo_url
      gpgcheck false
      metadata_expire "1"
      not_if { "rpm -qa | grep #{reponame}" }
    end
  else
    repodir = node['beachhead']['alt-yum-dir']
    yumdownloader_all_repos = "#{yumdownloader_all_repos}" + " -c #{repodir}/#{reponame}.repo"
    node.override['beachhead']["user"] = name
    node.override['beachhead']["group"] = name
    repopath = node['beachhead']['alt-yum-dir']
    template "#{repopath}/#{reponame}.repo" do
      source "#{reponame}.repo.erb"
      action :create
      variables( :repourl => "#{repo_url}" )
      owner "#{name}"
      group "#{name}"
    end
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
yum_options = "--nogpgcheck --downloadonly --downloaddir #{rpm_subdir}"

# TODO: MBACCHI Make this work with yumdownloader
# borrowed command from eucalyptus-service-image:
# yumdownloader --resolve -c /tmp/yum-tmp.conf --destdir /var/lib/eucalyptus-service-image/packages eucalyptus-imaging-worker load-balancer-servo euca2ools

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
    if node['beachhead']['use-yumdownloader']
      pkgname = "#{pkgname}-#{install}"
    else
      pkgname = "#{pkgname} #{install}"
    end
  end
  if node['beachhead']['use-yumdownloader']
    if node['beachhead']['alt-yum-config-location']
      execute "yumdownloader #{pkgname}" do
        command "yumdownloader --resolve #{yumdownloader_all_repos} --destdir #{rpm_subdir} #{pkgname}"
      end
    else
      execute "yumdownloader #{pkgname}" do
        command "yumdownloader --resolve --destdir #{rpm_subdir} #{pkgname}"
      end
    end
  else
    package pkgname do
      action :install
      options yum_options
    end
  end
end

package node['createrepo_pkg'] do
  action :install
end

cmd = node['createrepo_pkg']
bash "create_repo_data" do
  user beachhead_user
  cwd rpm_subdir
  code <<-EOH
    #{cmd} --database #{rpm_subdir}  
  EOH
end
