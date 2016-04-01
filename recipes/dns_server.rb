%w{bind bind-utils}.each do |pkg|
  yum_package pkg do
    action :upgrade
    flush_cache [:before]
  end
end

template "/etc/named.conf" do
  source "named.conf.erb"
  action :create
end

node['bind']['zones']['forward'].each do |zone|
  template "/var/named/#{zone['file']}" do
    source "namedzone.erb"
    action :create
    variables zone
  end
end

node['bind']['zones']['reverse'].each do |zone|
  template "/var/named/#{zone['file']}" do
    source "namedzone.erb"
    action :create
    variables zone
  end
end
