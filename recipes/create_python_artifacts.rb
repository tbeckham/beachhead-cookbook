#
# Cookbook Name:: beachhead-cookbook
# Recipe:: create_python_artifacts
# Used to create the virtual env for deployment and testing tools

include_recipe "beachhead-cookbook::default"

######################################################################################################################
# Create python virtual env to include in dependency archive
# Install all needed python modules into this env for portability, and including in the dependency beachhead archive.
######################################################################################################################

# Get the needed vars from the provided attributes
extra_pip_hash = node['beachhead']['extra_pip_pkgs']
python_git_hash = node['beachhead']['python_git_modules']
beachhead_user = node['beachhead']["user"]
beachhead_group = node['beachhead']["group"]
sandbox_dir = node['beachhead']['dependency_sandbox_dir']
python_subdir =  File.join(sandbox_dir, node['beachhead']['python_subdir'])
virt_env_path = File.join(python_subdir, "beachhead_virtualenv")
virt_activate = File.join(virt_env_path, "bin/activate")

directory python_subdir do
  owner beachhead_user
  group beachhead_group
  action :create
  recursive true
  not_if { "ls -l #{python_subdir}" }
end


Chef::Log.info "Making sure python-virtualenv package is installed..."
yum_package "python-virtualenv" do
  action :install
  not_if { "rpm -qa | grep python-virtualenv"}
end

# Create the virtual env
Chef::Log.info "Attempting to create the python virtual environment"
python_virtualenv virt_env_path do
  # interpreter "python2.7"
  owner beachhead_user
  group beachhead_group
  action :create
end

# Install any PIP packages specified into the virtual env
extra_pip_hash.each do |pkgname, install|
  pkg_version = nil
  if [true, false].include?(install)
    if not install
      next
    end
  else
    pkg_version = install
  end
  Chef::Log.info "Attempting to pip install: #{pkgname}"
  python_pip pkgname do
    virtualenv virt_env_path
    version pkg_version
  end
end

# Create/update the local git repos, checkout specified branch in the sandbox dir.
# Then Build/install the module into the virtual env
python_git_hash.each do |modname, values|
  if values['update']
    git_action = 'sync'
  else
    git_action = 'nothing'
  end
  local_gitdir = File.join(python_subdir, modname)
  Chef::Log.info "Creating/updating git module #{modname}, branch:#{values['branch']}"
  git modname do
    user beachhead_user
    group beachhead_group
    destination local_gitdir
    # checkout_branch values['branch']
    revision values['branch']
    action git_action
    repository values['git_repo']
  end
  Chef::Log.info "Installing module into virtual env:#{modname}"
  bash "install_python_source_#{modname}" do
    user beachhead_user
    cwd sandbox_dir
    code <<-EOH
      source #{virt_activate}
      cd #{local_gitdir} && python setup.py install; cd -
    EOH
  end
end
