yum_package 'mysql55' do
  action :nothing
  flush_cache [:before]
end
