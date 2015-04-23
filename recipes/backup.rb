chef_gem 'chef-rewind'

require 'chef/rewind'

include_recipe "rs-mysql::backup"

device_nickname = node['rs-mysql']['device']['nickname']

rewind rightscale_backup: device_nickname do
  lineage node['rs-mysql']['backup']['lineage']
  device_excludes node['slice_rs-mysql']['backup']['device_excludes']
  action :create
end
