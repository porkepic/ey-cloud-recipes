#
# Cookbook Name:: whenever
# Recipe:: default
#

if ['solo', 'util'].include?(node[:instance_role])

  # Set your application name here
  node[:applications].each do |app, data|
    ey_cloud_report "whenever" do
      message "starting whenever recipe for app '#{app}'"
    end
    # be sure to replace "app_name" with the name of your application.
    # local_user = node[:users].first
    execute "whenever" do
      cwd "/data/#{app}/current"
      epic_fail true
      command "bundle exec whenever --update-crontab '#{app}' 'environment=#{node[:environment][:framework_env]}'"
    end

    ey_cloud_report "whenever" do
      message "whenever recipe complete for app '#{app}'"
    end
  end

end



