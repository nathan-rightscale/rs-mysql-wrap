chef_gem 'chef-rewind'

require 'chef/rewind'

if node['slice_rs-mysql']['mysql']['log_bin'] != nil
  node.force_override['mysql']['server']['directories']['bin_log_dir'] = node['slice_rs-mysql']['mysql']['log_bin']
  node.force_override['mysql']['tunable']['log_bin'] = "#{node['slice_rs-mysql']['mysql']['log_bin']}/mysql-bin"
end

include_recipe 'database::mysql'
include_recipe "rs-mysql::default"

mysql_connection_info = {
  :host => 'localhost',
  :username => 'root',
  :password => node['rs-mysql']['server_root_password']
}

rewind mysql_database: 'application database' do
  connection mysql_connection_info
  database_name node['rs-mysql']['application_database_name']
  action :create
  not_if { node['rs-mysql']['application_database_name'].to_s.empty? || node['rs-mysql']['application_database_name'].to_s == '*.*' }
end
