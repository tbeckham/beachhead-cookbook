#
# Cookbook Name:: beachhead-cookbook
# Recipe:: http_server
#

include_recipe "beachead::default"

doc_root =  node['beachhead']["httpd"]["docroot"]
pageowner =  node['beachhead']["owner"]
pagegroup =  node['beachhead']["group"]
homepage = doc_root.concat('index.html')


httpd_service 'eucabeachhead' do
  mpm 'prefork'
  action [:create, :start]
end

# Add the site configuration.
httpd_config 'eucabeachead' do
  instance 'eucabeachead'
  source 'eucabeachead.conf.erb'
  notifies :restart, 'httpd_service[eucabeachead]'
end

# Create the document root directory.
directory doc_root do
  recursive true
end

# Write the home page.
file homepage do
  content '<html>This is the Euca-Beach-Head place holder</html>'
  mode '0644'
  owner pageowner
  group pagegroup
end