source "https://supermarket.chef.io"

metadata

cookbook 'collectd', git: 'https://github.com/rightscale-cookbooks-contrib/chef-collectd', branch: 'generalize_install_for_both_centos_and_ubuntu'
cookbook 'mysql', git: 'https://github.com/rightscale-cookbooks-contrib/mysql', branch: 'rs-fixes'
cookbook 'dns', git: 'https://github.com/rightscale-cookbooks-contrib/dns', branch: 'rightscale_development_v2'
cookbook 'build-essential', '~> 1.4.4'
cookbook 'database', git: 'https://github.com/rightscale-cookbooks-contrib/database', branch: 'rs-fixes'
cookbook 'rs-mysql', git: 'https://github.com/rightscale-cookbooks/rs-mysql', tag:'v1.1.6'
cookbook 'yum-ius', git: 'https://github.com/nathan-rightscale/yum-ius'
cookbook 'rightscale_backup', path: '/home/nathan_brewer/rs_clients/slice/rightscale_backup'

group :integration do
cookbook 'curl', '~> 2.0.0'
cookbook 'fake', path: './test/cookbooks/fake'
cookbook 'rhsm', '~> 1.0.0'
end