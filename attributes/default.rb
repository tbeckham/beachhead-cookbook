#####################################################################################################################
# beachhead base attributes
######################################################################################################################
default['beachhead']["user"] = "eucalyptus"
default['beachhead']["group"] = "eucalyptus"

######################################################################################################################
# beachhead repos. Repos urls to be created locally and used for creating archive/repo of deployment dependencies
######################################################################################################################
default['beachhead']['add_epel'] = true
default['beachhead']['repos']={
    "enterprise-repo" => "http://builds.qa1.eucalyptus-systems.com/packages/tags/enterprise-devel/rhel/7/x86_64/",
    "euca2ools-repo" => "http://builds.qa1.eucalyptus-systems.com/packages/tags/euca2ools-devel/rhel/7/x86_64/",
    "eucalyptus-repo" => "http://builds.qa1.eucalyptus-systems.com/packages/tags/eucalyptus-devel/rhel/7/x86_64/"
}
# This is used to control whether the yum repo config files
# will be placed in the standard /etc/yum.repos.d or /tmp (default /tmp)
default['beachhead']['alt-yum-config-location'] = true
default['beachhead']["alt-yum-dir"] = "/tmp"

# Default to using yumdownloader vs. yum with the --downloadonly argument
default['beachhead']['use-yumdownloader'] = true

######################################################################################################################
# beachhead http server attributes
######################################################################################################################
default['beachhead']["httpd"]["docroot"]='/var/www/eucabeachead/public_html'

######################################################################################################################
# beachhead dependency sandbox location used to store local packages
######################################################################################################################
default['beachhead']['dependency_sandbox_dir']="/tmp/beachhead_dependencies"
default['beachhead']['dependency_archive_name']="eucalyptus_dependencies.tar.xz"

# Should we overwrite dependencies in dependency_sandbox_dir?  Default: false
default['beachhead']['always_overwrite_dependencies'] = false

######################################################################################################################
# beachhead python environment
#python modules to be installed into the python virtual environement
######################################################################################################################
# Sub dir within the dependency dir for python dependency artifiacts 
default['beachhead']['python_subdir']="python"

#Python git modules
default['beachhead']['python_git_modules'] = {
      "calyptos" => {'git_repo'=> "https://github.com/eucalyptus/calyptos.git",
                     'branch' => "master",
                     'update' => true
      },
      "nephoria" => {'git_repo'=> "https://github.com/eucalyptus/nephoria.git",
                     'branch' => "master",
                     'update' => true
      },
      "adminapi" => {'git_repo'=> "https://github.com/eucalyptus/adminapi.git",
                     'branch' => "master",
                     'update' => true
      },
      "n4j" => {'git_repo'=> "https://github.com/eucalyptus/n4j.git",
                     'branch' => "master",
                     'update' => true
      },
}
# Extra python packages to be installed with pip into the virtual environment
default['beachhead']['extra_pip_pkgs']={}

######################################################################################################################
# beachhead rpms for building local repo and archive of Euca deployment packages
# package lists are in the hash format "package_name": => "version, true, or false"
# Where:
#       "version" will attempt to download that version of the package
#       "true": will attempt to download that package name w/o regard for version
#       "false": will not download this package
######################################################################################################################
# Sub dir within the dependency dir for python dependency artifiacts 
default['beachhead']['rpm_subdir']="rpms"

# Base yum packages to be downloaded into the local repo/archive
default['beachhead']['system_rpms']={"gcc" => true,
                              "git" => true,
                              "libffi-devel" => true,
                              "openssl-devel" => true,
                              "patch" => true,
                              "python-virtualenv"=> true,
                              "python-pip" => true,
                              "python-devel" => true,
                              "python-setuptools" => true,
                              "readline-devel" => true}
# Euca specific yum packages to be downloaded into the local repo/archive
default['beachhead']['euca_rpms']={"eucalyptus" => "4.4.0" ,
                            "eucalyptus-admin-tools" => true,
                            "eucalyptus-axis2c-common" => true,
                            "eucalyptus-blockdev-utils" => true,
                            "eucalyptus-cc" => true,
                            "eucalyptus-cloud" => true,
                            "eucalyptus-common-java" => true,
                            "eucalyptus-common-java-libs" => true,
                            "eucalyptus-debuginfo" => true,
                            "eucalyptus-imaging-toolkit" => true,
                            "eucalyptus-imaging-worker" => true,
                            "eucalyptus-nc" => true,
                            "eucalyptus-sc" => true,
                            "eucalyptus-service-image" => true,
                            "eucalyptus-selinux" => true,
                            "eucalyptus-sos-plugins" => true,
                            "eucalyptus-walrus" => true,
                            "euca2ools" => true,
                            "eucaconsole" => true,
                            "eucaconsole-selinux" => true,
                            "eucanetd" => true,
                            "load-balancer-servo" => true}
# Eucalyptus Enterprise rpms
default['beachhead']['euca_enterprise_rpms']={}

# VPC backend rpms
default['beachhead']['euca_backend_rpms']={}
# Add backend specific rpms here:
#['beachhead']['euca_backend_rpms']['midokura'] = false
#['beachhead']['euca_backend_rpms']['riak'] = false
#['beachhead']['euca_backend_rpms']['ceph'] = false

# Extra yum packages to be downloaded into the local repo/archive
default['beachhead']['extra_rpms']={
  "qemu-img-ev"  => true,
  "qemu-kvm-common-ev"  => true,
  "qemu-kvm-ev"  => true,
  "qemu-kvm-tools-ev"  => true
}

######################################################################################################################
# Additional artifacts to be downloaded into the local repo/archive
######################################################################################################################
default['beachhead']['download_urls'] = {
    "default_img_url" => "http://images.objectstorage.cloud.qa1.eucalyptus-systems.com:8773/precise-server-cloudimg-amd64-disk1.img",
    "init_script_url" => "http://git.qa1.eucalyptus-systems.com/qa-repos/eucalele/raw/master/deploy-helpers/scripts/network-interfaces.sh"
}

######################################################################################################################
# DNS Configuration
######################################################################################################################
default['bind']['config']['recursion'] = "yes"
default['bind']['config']['dnssec-enable'] = "no"
default['bind']['config']['dnssec-validation'] = "no"
default['bind']['config']['dnssec-lookaside'] = "auto"

# createrepo package can be specified here, default is createrepo_c
default['createrepo_pkg'] = "createrepo_c"
