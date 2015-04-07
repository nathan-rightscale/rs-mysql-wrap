chef_gem 'chef-rewind'

require 'chef/rewind'

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
