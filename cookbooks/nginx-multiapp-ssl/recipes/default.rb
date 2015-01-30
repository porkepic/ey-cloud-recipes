#
# Cookbook Name: nginx-multiapp-ssl
# Recipe: default
#

node[:applications].each do |app, data|
  template "/etc/nginx/servers/#{app}.ssl.conf" do
    owner 'deploy' 
    group 'deploy'
    source "ssl.conf.erb" 
    variables({ 
      :app => app,
      :vhost => data[:vhosts].first[:name]
    })
  end
end 

execute "sudo /etc/init.d/nginx reload"
