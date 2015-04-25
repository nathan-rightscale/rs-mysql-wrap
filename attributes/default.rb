case node["platform_family"]
when "rhel"
  default['slice_rs-mysql']['mysql']['version'] = nil

  node.override['mysql']['client']['packages'] = %w[mysql55 mysql55-devel]
  node.override['mysql']['server']['packages'] = %w[mysql55-server]
end

default['slice_rs-mysql']['mysql']['log_bin'] = nil
