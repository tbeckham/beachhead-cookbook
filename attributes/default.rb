
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
######################################################################################################################
['beachhead']['calyptos_git_url']="https://github.com/eucalyptus/calyptos.git"
['beachhead']['calyptos_branch']="master"
['beachhead']['nephoria_git_url']="https://github.com/nephomaniac/nephoria.git"
['beachhead']['nephoria_branch']="master"
['beachhead']['adminapi_git_url']="https://github.com/nephomaniac/adminapi.git"
['beachhead']['adminapi_branch']="master"

['beachhead']['python_pkgs']=["calyptos", "adminapi"]



######################################################################################################################
# beachhead rpms for building local repo and archive of Euca deployment packages
# package lists are in the hash format "package_name": => "version, true, or false"
# Where:
#       "version" will attempt to download that version of the package
#       "true": will attempt to download that package name w/o regard for version
#       "false": will not download this package
######################################################################################################################
['beachhead']['calyptos_git_url']="https://github.com/eucalyptus/calyptos.git"

['beachhead']['system_rpms']={"gcc" => true,
                             "python-virtualenv"=> true,
                             "python-pip" => true,
                             "python-devel" => true,
                             "git" => true,
                             "python-setuptools" => true}

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

['beachhead']['extra_rpms'] = {}



