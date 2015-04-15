chef_gem 'chef-rewind'

require 'chef/rewind'

include_recipe "rs-mysql::schedule"

schedule_enable = node['rs-mysql']['schedule']['enable'] == true || node['rs-mysql']['schedule']['enable'] == 'true'
lineage = lineage = node['rs-mysql']['backup']['lineage']

rewind cron: "backup_schedule_#{lineage}" do
  minute node['rs-mysql']['schedule']['minute']
  hour node['rs-mysql']['schedule']['hour']
  command "rs_run_recipe --policy 'slice_rs-mysql::backup' --name 'slice_rs-mysql::backup'"
  action schedule_enable ? :create : :delete
end
