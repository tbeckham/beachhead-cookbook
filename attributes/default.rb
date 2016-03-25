######################################################################################################################
# beachhead base attributes
######################################################################################################################
['beachhead']["user"] = 'eucalyptus'
['beachhead']["group"] = 'eucalyptus'

######################################################################################################################
# beachhead http server attributes
######################################################################################################################
['beachhead']["httpd"]["docroot"]='/var/www/eucabeachead/public_html'

######################################################################################################################
# beachhead dependency sandbox location used to store local packages
######################################################################################################################
['beachhead']['dependency_sandbox_dir']="eucalyptus_dependencies.tar.gz"

######################################################################################################################
# beachhead python environment
#python modules to be installed into the python virtual environement
######################################################################################################################

['beachhead']['python_git_modules'] = {
      "calyptos" => {'git_url'=> "https://github.com/eucalyptus/calyptos.git",
                     'branch' => "master",
                     'update' => true
      },
      "nephoria" => {'git_url'=> "https://github.com/nephomaniac/nephoria.git",
                     'branch' => "master",
                     'update' => true
      },
      "adminapi" => {'git_url'=> "https://github.com/nephomaniac/adminapi.git",
                     'branch' => "master",
                     'update' => true
      },
}
# Extra python packages to be installed with pip into the virtual environment
['beachhead']['extra_pip_pkgs']={"ipython" => true}

######################################################################################################################
# beachhead rpms for building local repo and archive of Euca deployment packages
# package lists are in the hash format "package_name": => "version, true, or false"
# Where:
#       "version" will attempt to download that version of the package
#       "true": will attempt to download that package name w/o regard for version
#       "false": will not download this package
######################################################################################################################
# Base yum packages to be downloaded into the local repo/archive
['beachhead']['system_rpms']={"gcc" => true,
                              "python-virtualenv"=> true,
                              "python-pip" => true,
                              "python-devel" => true,
                              "git" => true,
                              "python-setuptools" => true}
# Euca specific yum packages to be downloaded into the local repo/archive
['beachhead']['euca_rpms']={"eucalyptus" => "4.3.0" ,
                            "eucalyptus-admin-tool" => true,
                            "eucalyptus-axis2c-common" => true,
                            "eucalyptus-blockdev-utils" => true,
                            "eucalyptus-cc" => true,
                            "eucalyptus-cloud" => true,
                            "eucalyptus-common-java" => true,
                            "eucalyptus-common-java-libs" => true,
                            "eucalyptus-database-server" => true,
                            "eucalyptus-debuginfo" => true,
                            "eucalyptus-imaging-toolkit" => true,
                            "eucalyptus-imaging-worker" => true,
                            "eucalyptus-nc" => true,
                            "eucalyptus-release-ci" => true,
                            "eucalyptus-sc" => true,
                            "eucalyptus-service-image" => true,
                            "eucalyptus-service-image-release" => true,
                            "eucalyptus-sos-plugins" => true,
                            "eucalyptus-walrus" => true,
                            "calyptos" => true,
                            "euca-deploy" => true,
                            "euca2ools" => "3.3.0",
                            "eucaconsole" => true,
                            "eucalyptus-load-balancer-image" => true,
                            "eucanetd" => true,
                            "load-balancer-servo" => true}
# Extra yum packages to be downloaded into the local repo/archive
['beachhead']['extra_rpms'] = {}



