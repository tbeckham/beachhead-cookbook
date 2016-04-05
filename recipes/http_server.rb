#
# Cookbook Name:: beachhead-cookbook
# Recipe:: http_server
#

include_recipe "beachhead-cookbook::default"

doc_root =  node['beachhead']["httpd"]["docroot"]
pageowner =  node['beachhead']["owner"]
pagegroup =  node['beachhead']["group"]
homepage = File.join(doc_root, 'index.html')


httpd_service 'euca_beach_head' do
  mpm 'prefork'
  action [:create, :start]
end

# Add the site configuration.
httpd_config 'euca_beach_head' do
  instance 'euca_beach_head'
  source 'euca_beach_head_web.conf.erb'
  notifies :restart, 'httpd_service[euca_beach_head]'
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
