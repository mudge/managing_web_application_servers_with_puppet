!SLIDE
# Users

!SLIDE

    @@@ ruby
    group { 'mcp':
      ensure => present,
    }

    user { 'mcp':
      ensure     => present,
      gid        => 'mcp',
      home       => '/home/mcp',
      managehome => true,
    }

!SLIDE prettify
# A word about ordering

!SLIDE

    @@@ ruby
    group { 'mcp':
      ensure => present,
    }

    Group['mcp']

!SLIDE

    @@@ ruby
    user { 'mcp':
      ensure  => present,
      require => Group['mcp'],
    }

!SLIDE

    @@@ ruby
    user { 'mcp':
      ensure => present,
      require => Group['mcp'],
    }

    group { 'mcp':
      ensure => present,
      require => User['mcp'],
    }

!SLIDE smaller

    err: Could not apply complete catalog:
    Found dependency cycles in the following
    relationships:
    User[mcp] => Group[mcp], Group[mcp] => User[mcp];
    try using the '--graph' option and open the '.dot'
    files in OmniGraffle or GraphViz

!SLIDE
# SSH keys

!SLIDE

    @@@ ruby
    ssh_authorized_key { 'mcp-mudge':
      ensure => present,
      key    => 'AAAAB3NzaC1yc2EAAAAB...',
      type   => dsa,
      user   => 'mcp',
    }

!SLIDE
# Directories

!SLIDE

    @@@ ruby
    file {
      '/home/mcp/apps':
        ensure => directory,
        owner  => 'mcp',
        group  => 'mcp';

      '/home/mcp/apps/mcp':
        ensure => directory,
        owner  => 'mcp',
        group  => 'mcp';

!SLIDE

    @@@ ruby
      '/home/mcp/apps/mcp/shared':
        ensure => directory,
        owner  => 'mcp',
        group  => 'mcp';

      '/home/mcp/apps/mcp/shared/config':
        ensure => directory,
        owner  => 'mcp',
        group  => 'mcp';
    }

!SLIDE
# Sensitive configuration

!SLIDE smaller

    @@@ ruby
    file { '...config/database.yml':
      ensure => present,
      owner  => 'mcp',
      group  => 'mcp',
      source => 'puppet:///modules/mcp/database.yml',
    }

!SLIDE
# The power of `source`

!SLIDE smaller

    @@@ ruby
    file { '/some/config.yml':
      source => [
        'puppet:///confidential/config.yml',
        'puppet:///modules/mcp/config.yml'
      ],
    }

!SLIDE
# Dealing with Test, Staging <span>&</span> Live

!SLIDE smaller

    @@@ ruby
    file { '/some/config.yml':
      source => [
        "puppet:///confidential/config.yml.$hostname",
        "puppet:///confidential/config.yml.$tier",
        'puppet:///modules/mcp/config.yml'
      ],
    }

!SLIDE smaller

    @@@ ruby
    $tier = 'test'
    # => "puppet:///confidential/config.yml.test"

    $tier = 'staging'
    # => "puppet:///confidential/config.yml.staging"

    $tier = 'live'
    # => "puppet:///confidential/config.yml.live"

!SLIDE
# Problems with this approach

!SLIDE smaller

    @@@ ruby
    $db_username = 'bob'
    $db_password = 'letmein'

    file { '/some/database.yml':
      content => template('mcp/database.yml.erb'),
    }

!SLIDE

    @@@ ruby
    production:
      adapter: mysql
      username: <%= db_username %>
      password: <%= db_password %>

!SLIDE
# `extlookup`, ENCs, etc.

!SLIDE
# RVM <span>&</span> Ruby

!SLIDE

    @@@ ruby
    package { 'rvm-dependencies':
      ensure => installed,
      name   => [
        'curl',
        'git-core',
        'subversion',
        'build-essential',
        ...
      ],
    }

!SLIDE smaller

    @@@ ruby
    file { '/root/rvm-installer':
      ensure => present,
      owner  => 'root',
      group  => 'root',
      mode   => '0700',
      source => 'puppet:///modules/mcp/rvm',
    }

!SLIDE smaller

    @@@ ruby
    exec { 'install-rvm':
      command => '/root/rvm-installer --version 1.6.32',
      cwd     => '/root',
      unless  => 'grep 1.6.32 /usr/local/rvm/VERSION',
      path    => '/usr/bin:/usr/sbin:/bin:/sbin',
    }

!SLIDE smaller

    @@@ ruby
    exec { 'rvm install ruby-1.9.2-p290':
      creates => '/usr/local/rvm/rubies/ruby-1.9.2-p290',
      timeout => 1800,
      path    => '/usr/local/rvm/bin:/usr/bin...',
      require => File['install-rvm'],
    }

!SLIDE
# nginx <span>&</span> Passenger

!SLIDE smaller

    @@@ ruby
    exec { 'install-passenger-3.0.8':
      command => 'rvm-shell ... -c "gem install pas..."',
      unless  => 'rvm-shell ... -c "gem list passen..."',
      path    => '/usr/local/rvm/bin:/usr/bin:...',
      timeout => 1800,
      require => Exec['rvm install ruby-1.9.2-p290'],
    }

!SLIDE smaller

    $ rvm-shell ruby-1.9.2-p290 -c \
      "gem install passenger -v3.0.8"

    $ rvm-shell ruby-1.9.2-p290 -c \
      "gem list passenger -v3.0.8 -i"

!SLIDE smaller

    @@@ ruby
    exec { 'install-nginx':
      command => 'rvm-shell ... -c "passenger-..."',
      creates => '...agents/nginx/PassengerHelperAgent',
      timeout => 1800,
      path    => '/usr/local/rvm/bin:/usr/bin:...',
      require => Exec['install-passenger-3.0.8'],
    }

!SLIDE smaller

    $ rvm-shell ruby-1.9.2-p290 -c \
      "passenger-install-nginx-module --auto \
      --auto-download \
      --prefix=/opt/nginx"

!SLIDE smaller

    @@@ ruby
    file {
      '/opt/nginx/conf/sites_available/mcp.conf':
        ensure => present,
        owner  => 'root',
        group  => 'root',
        source => 'puppet:///modules/mcp/mcp.conf';

      '/opt/nginx/conf/sites_enabled/mcp.conf':
        ensure => link,
        owner  => 'root',
        group  => 'root',
        target => '/opt/nginx/c...vailable/mcp.conf',
    }

!SLIDE smaller

    @@@ ruby
    file { '/etc/init.d/nginx':
      ensure => present,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      source => 'puppet:///modules/mcp/nginx',
      require => Exec['install-nginx'];
    }

!SLIDE smaller

    @@@ ruby
    service { 'nginx':
      ensure     => running,
      enable     => true,
      hasrestart => true,
      hasstatus  => true,
      subscribe  => File['/opt/nginx/conf/nginx.conf'],
      require => [
        File['/opt/nginx/conf/nginx.conf'],
        File['/etc/init.d/nginx']
      ],
    }
