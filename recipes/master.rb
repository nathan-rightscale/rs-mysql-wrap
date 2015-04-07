chef_gem 'chef-rewind'

require 'chef/rewind'

master_fqdn = "#{node['slice_rs-mysql']['dns']['hostname']}.#{node['slice_rs-mysql']['dns']['domain']}"
node.override['rs-mysql']['dns']['master_fqdn'] = master_fqdn

include_recipe "rs-mysql::master"

dns_name = master_fqdn.split('.').first

rewind :dns => dns_name  do
  provider 'dns_dnsmadeeasy_api20'
  domain domain_name
  credentials(
    'dnsmadeeasy_api_key' => node['rs-mysql']['dns']['user_key'],
    'dnsmadeeasy_secret_key' => node['rs-mysql']['dns']['secret_key'],
  )
  entry_name node['slice_rs-mysql']['dns']['hostname']
  entry_value node['mysql']['bind_address']
  type node['dns']['entry']['type']
  ttl 60
end
