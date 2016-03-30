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
