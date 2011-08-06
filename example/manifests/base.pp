group { 'mcp':
  ensure => present,
}

user { 'mcp':
  ensure     => present,
  gid        => 'mcp',
  home       => '/home/mcp',
  managehome => true,
}

ssh_authorized_key { 'mcp-mudge':
  ensure => present,
  key    => 'AAAAB3NzaC1yc2EAAAAB...',
  type   => dsa,
  user   => 'mcp',
}

file {
  '/home/mcp/apps':
    ensure => directory,
    owner  => 'mcp',
    group  => 'mcp';

  '/home/mcp/apps/mcp':
    ensure => directory,
    owner  => 'mcp',
    group  => 'mcp';

  '/home/mcp/apps/mcp/shared':
    ensure => directory,
    owner  => 'mcp',
    group  => 'mcp';

  '/home/mcp/apps/mcp/shared/config':
    ensure => directory,
    owner  => 'mcp',
    group  => 'mcp';

  '/home/mcp/apps/mcp/shared/config/database.yml':
    ensure => present,
    owner  => 'mcp',
    group  => 'mcp',
    source => 'puppet:///modules/mcp/database.yml';
}

package { 'rvm-dependencies':
  ensure => installed,
  name   => [
    'curl',
    'git-core',
    'subversion',
    'build-essential',
    'bison',
    'openssl',
    'libreadline6',
    'libreadline6-dev',
    'zlib1g',
    'zlib1g-dev',
    'libssl-dev',
    'libyaml-dev',
    'libsqlite3-0',
    'libsqlite3-dev',
    'sqlite3',
    'libxml2-dev',
    'libxslt-dev',
    'autoconf',
    'libc6-dev',
    'ncurses-dev',
    'libcurl4-openssl-dev'
  ],
}

file { '/root/rvm-installer':
  ensure => present,
  owner  => 'root',
  group  => 'root',
  mode   => '0700',
  source => 'puppet:///modules/mcp/rvm',
}

exec { 'install-rvm':
  command => '/root/rvm-installer --version 1.6.32',
  cwd     => '/root',
  unless  => 'grep 1.6.32 /usr/local/rvm/VERSION',
  path    => '/usr/bin:/usr/sbin:/bin:/sbin',
  require => Package['rvm-dependencies'],
}

file { '/etc/gemrc':
  ensure  => present,
  content => "---\ninstall: --no-rdoc --no-ri\nupdate: --no-rdoc --no-ri\n",
}

file { 'global.gems':
  ensure  => present,
  path    => '/usr/local/rvm/gemsets/global.gems',
  content => "rake -v0.8.7\nbundler\n",
  require => Exec['install-rvm'],
}

exec { 'rvm install ruby-1.9.2-p290':
  creates => '/usr/local/rvm/rubies/ruby-1.9.2-p290',
  timeout => 1800,
  path    => '/usr/local/rvm/bin:/usr/bin:/usr/sbin:/bin:/sbin',
  require => File['/usr/local/rvm/gemsets/global.gems'],
}

exec { 'install-passenger-3.0.8':
  command => 'rvm-shell ruby-1.9.2-p290 -c "gem install passenger -v3.0.8"',
  unless  => 'rvm-shell ruby-1.9.2-p290 -c "gem list passenger -v3.0.8 -i"',
  path    => '/usr/local/rvm/bin:/usr/bin:/usr/sbin:/bin:/sbin',
  timeout => 1800,
  require => Exec['rvm install ruby-1.9.2-p290'],
}

exec { 'install-nginx':
  command => 'rvm-shell ruby-1.9.2-p290 -c "passenger-install-nginx-module --auto --auto-download --prefix=/opt/nginx"',
  creates => '/usr/local/rvm/gems/ruby-1.9.2-p290/gems/passenger-3.0.8/agents/nginx/PassengerHelperAgent',
  timeout => 1800,
  path    => '/usr/local/rvm/bin:/usr/bin:/usr/sbin:/bin:/sbin',
  require => Exec['install-passenger-3.0.8'],
}

file {
  '/opt/nginx/conf/sites_available':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    require => Exec['install-nginx'];

  '/opt/nginx/conf/sites_enabled':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    require => Exec['install-nginx'];

  '/opt/nginx/conf/nginx.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/mcp/nginx.conf',
    require => Exec['install-nginx'];

  '/opt/nginx/conf/sites_available/mcp.conf':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/mcp/mcp.conf',
    notify => Service['nginx'];

  '/opt/nginx/conf/sites_enabled/mcp.conf':
    ensure => link,
    owner  => 'root',
    group  => 'root',
    target => '/opt/nginx/conf/sites_available/mcp.conf',
    notify => Service['nginx'];

  '/etc/init.d/nginx':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => 'puppet:///modules/mcp/nginx',
    require => Exec['install-nginx'];
}

service { 'nginx':
  ensure     => running,
  enable     => true,
  hasrestart => true,
  hasstatus  => true,
  subscribe  => File['/opt/nginx/conf/nginx.conf'],
  require    => [
    File['/opt/nginx/conf/nginx.conf'],
    File['/etc/init.d/nginx']
  ],
}
