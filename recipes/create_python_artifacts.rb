#
# Cookbook Name:: beachhead-cookbook
# Recipe:: create_python_artifacts
# Used to create the virtual env for deployment and testing tools

include_recipe "beachead::default"

extra_pip_hash = node['beachhead']['extra_pip_pkgs']
python_git_hash = node['beachhead']['python_git_modules']
beachhead_user = node['beachhead']["user"]
beachhead_group = node['beachhead']["group"]
sandbox_dir = node['beachhead']['dependency_sandbox_dir']
archive_name = node['beachhead']['dependency_archive_name']
virt_env_path = File.join(sandbox_dir, "beachhead_virtualenv")
virt_activate = File.join(virt_env_path, "bin/activate")

######################################################################################################################
# Create python virtual env to include in dependency archive
######################################################################################################################

python_virtualenv virt_env_path do
  # interpreter "python2.7"
  owner beachhead_user
  group beachhead_group
  action :create
end


# Install any PIP packages into the virtual env
extra_pip_hash.each do |pkgname, install|
  pkg_version = nil
  if install.is_a?(Boolean)
    if not install
      next
    end
  else
    pkg_version = install
  end
  python_pip key do
    virtualenv virt_env_path
    version pkg_version
  end
end

# Create the local git repos in the sandbox dir
python_git_hash.each do |modname, values|
  if values['update']
    git_action = 'sync'
  else
    git_action = 'nothing'
  end
  local_gitdir = File.join(sandbox_dir, modname)
  git modname do
    user beachhead_user
    group beachhead_group
    destination local_gitdir
    checkout_branch values['branch']
    action git_action
    repository values['git_repo']
  end
  bash "install_python_source_#{modname}" do
    user beachhead_user
    cwd sandbox_dir
    code <<-EOH
      source #{virt_activate}
      cd #{local_gitdir} && python setup.py install; cd -
    EOH
  end
end




