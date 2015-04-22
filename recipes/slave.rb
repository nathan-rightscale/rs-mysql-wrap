if node['slice_rs-mysql']['mysql']['log_bin'] != nil
  node.force_override['mysql']['server']['directories']['bin_log_dir'] = node['slice_rs-mysql']['mysql']['log_bin']
  node.force_override['mysql']['tunable']['log_bin'] = "#{node['slice_rs-mysql']['mysql']['log_bin']}/mysql-bin"
end

include_recipe "rs-mysql::slave"
