#
# Cookbook Name:: resque
# Recipe:: default
#
if ['solo', 'util'].include?(node[:instance_role])
  
  execute "install shoryuken gem" do
    command "gem install shoryuken -r"
    not_if { "gem list | grep shoryuken" }
  end

  worker_count = 1

  template "/engineyard/bin/shoryuken" do
    owner 'root' 
    group 'root' 
    mode 0755
    source "shoryuken" 
    variables({}) 
  end

  node[:applications].each do |app, data|
    template "/etc/monit.d/shoryuken_#{app}.monitrc" do
      owner 'root' 
      group 'root' 
      mode 0644 
      source "monitrc.conf.erb" 
      variables({ 
      :num_workers => worker_count,
      :app_name => app, 
      :rails_env => node[:environment][:framework_env] 
      }) 
    end

    execute "ensure-shoryuken-is-setup-with-monit" do 
      epic_fail true
      command %Q{ 
      monit reload 
      } 
    end
  end 
end
