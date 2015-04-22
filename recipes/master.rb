chef_gem 'chef-rewind'

require 'chef/rewind'

if node['slice_rs-mysql']['mysql']['log_bin'] != nil
  node.force_override['mysql']['server']['directories']['bin_log_dir'] = node['slice_rs-mysql']['mysql']['log_bin']
  node.force_override['mysql']['tunable']['log_bin'] = "#{node['slice_rs-mysql']['mysql']['log_bin']}/mysql-bin"
end

master_fqdn = "#{node['slice_rs-mysql']['dns']['hostname']}.#{node['slice_rs-mysql']['dns']['domain']}"
node.override['rs-mysql']['dns']['master_fqdn'] = master_fqdn

include_recipe "rs-mysql::master"

missing_dns_creds = RsMysql::Helper.find_missing_dns_credentials(node)
if missing_dns_creds.empty?
  dns_name = master_fqdn.split('.').first
  rewind :dns => dns_name  do
    provider 'dns_dnsmadeeasy_api20'
    domain node['slice_rs-mysql']['dns']['domain']
    credentials(
      'dnsmadeeasy_api_key' => node['rs-mysql']['dns']['user_key'],
      'dnsmadeeasy_secret_key' => node['rs-mysql']['dns']['secret_key'],
    )
    entry_name node['slice_rs-mysql']['dns']['hostname']
    entry_value node['mysql']['bind_address']
    type node['dns']['entry']['type']
    ttl 60
  end
else
  missing_dns_creds.map! { |cred| "rs-mysql/dns/#{cred}" }
  log "Following DNS credentials are missing #{missing_dns_creds.join(', ')}! Skipping DNS setting..."
end

# Manually running the recipe as a operational script fixes this problem.

# # rs-mysql::stripe contains a bug that deletes the mysql directory
# # causing the service to re-initialize the database after execution
# # The code below attempts to fix this
# def slice_install_grants_cmd
#   str = '/usr/bin/mysql'
#   str << ' -u root '
#   node['mysql']['server_root_password'].empty? ? str << ' < /etc/mysql_grants.sql' : str << " --password=#{node['mysql']['server_root_password']} < /etc/mysql_grants.sql"
# end

# service "mysql" do
#   action :restart
# end

# cmd = slice_install_grants_cmd

# execute 'slice_install-grants' do
#   command cmd
#   action :run
# end
