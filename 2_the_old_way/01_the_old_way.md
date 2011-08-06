!SLIDE prettify
# A typical Rails application
## "mcp"

!SLIDE incremental commandline

    $ ls mcp
    Capfile      config       log
    Gemfile      config.ru    public
    Gemfile.lock db           script
    README       doc          spec
    Rakefile     features     tmp
    app          lib          vendor

!SLIDE incremental commandline

    $ bundle exec rspec spec
    ................

    Finished in 0.00816 seconds
    Many, many examples, 0 failures

!SLIDE prettify
# Let's prepare a server

!SLIDE
# Some assumptions

!SLIDE incremental commandline

    $ ssh mudge@server1
    Last login: Mon Aug  1 21:08:06 2011
    from 123-45-67-89.

!SLIDE
# Users

!SLIDE incremental commandline

    $ /usr/sbin/adduser -h
    adduser [--home DIR] [--shell SHELL]
    [--no-create-home] [--uid ID] [--firstuid ID]
    [--lastuid ID] [--gecos GECOS]
    [--ingroup GROUP | --gid ID]
    [--disabled-password] [--disabled-login]
    [--encrypt-home] USER
       Add a normal user

!SLIDE incremental commandline

    $ sudo -i
    # adduser mcp
    Adding user `mcp' ...
    Adding new group `mcp' (1002) ...
    Adding new user `mcp' (1001) with group `mcp' ...
    Creating home directory `/home/mcp' ...
    Copying files from `/etc/skel' ...
    Enter new UNIX password: 
    Retype new UNIX password: 
    ...
    Is the information correct? [Y/n] 

!SLIDE
# SSH Keys

!SLIDE incremental commandline

    # mkdir -m 700 ~mcp/.ssh
    # vi ~mcp/.ssh/authorized_keys
    # chmod 600 ~mcp/.ssh/authorized_keys
    # chown -R mcp: ~mcp/.ssh

!SLIDE
# Directories

!SLIDE incremental commandline

    # mkdir -p ~mcp/apps/mcp/shared/config
    # chown -R mcp: ~mcp/apps

!SLIDE
# Sensitive configuration

!SLIDE incremental commandline

    # cd ~mcp/apps/mcp/shared/config
    # vi database.yml
    # chown mcp: database.yml

!SLIDE
# RVM <span>&</span> Ruby

!SLIDE incremental commandline

    # apt-get install curl git-core subversion
    Reading package lists... Done
    Building dependency tree
    Reading state information... Done

!SLIDE incremental commandline

    # cd /root
    # curl -s \
      https://rvm.beginrescueend.com/install/rvm \
      -o rvm-installer
    # chmod +x rvm-installer
    # ./rvm-installer --version 1.6.32
    Installation of RVM to /usr/local/rvm/ is
    complete.

!SLIDE incremental commandline

    # apt-get install build-essential bison \
      openssl libreadline6 libreadline6-dev \
      zlib1g zlib1g-dev libssl-dev libyaml-dev \
      libsqlite3-0 libsqlite3-dev sqlite3 \
      libxml2-dev libxslt-dev autoconf \
      libc6-dev ncurses-dev

!SLIDE incremental commandline

    # vi /usr/local/rvm/gemsets/global.gems
    # ^vi^cat
    rake -v0.8.7
    bundler

!SLIDE incremental commandline

    # vi /etc/gemrc
    # ^vi^cat
    ---
    install: --no-rdoc --no-ri
    update:  --no-rdoc --no-ri

!SLIDE incremental commandline

    # rvm install 1.9.2-p290
    Installing Ruby from source to:
    /usr/local/rvm/rubies/ruby-1.9.2-p290, this
    may take a while depending on your cpu(s)...
    Install of ruby-1.9.2-p290 - #complete 

!SLIDE
# nginx <span>&</span> Passenger

!SLIDE incremental commandline

    # source /usr/local/rvm/scripts/rvm
    # rvm use 1.9.2-p290
    Using /usr/local/rvm/gems/ruby-1.9.2-p290
    # gem install passenger -v3.0.8
    Fetching: fastthread-1.0.7.gem (100%)
    Building native extensions.  This could
    take a while...
    Fetching: daemon_controller-0.2.6.gem (100%)
    Fetching: rack-1.3.2.gem (100%)
    ...
    Successfully installed passenger-3.0.8

!SLIDE incremental commandline

    # apt-get install libcurl4-openssl-dev
    Reading package lists... Done
    Building dependency tree
    Reading state information... Done
    # passenger-install-nginx-module
    Welcome to the Phusion Passenger Nginx
    module installer, v3.0.8.

!SLIDE incremental commandline

    # cd /opt/nginx/conf
    # mkdir sites_available sites_enabled
    # vi nginx.conf
    # cd sites_available
    # vi mcp.conf
    # ln -s \
      /opt/nginx/conf/sites_available/mcp.conf \
      /opt/nginx/conf/sites_enabled/mcp.conf

!SLIDE incremental commandline

    # vi /etc/init.d/nginx
    # chmod +x /etc/init.d/nginx
    # update-rc.d -f nginx defaults
    # /etc/init.d/nginx start
    Starting nginx: nginx

!SLIDE
# Capistrano

!SLIDE incremental commandline

    $ cap deploy:setup
    $ cap deploy:check
    $ cap deploy:cold

!SLIDE prettify
# What's wrong with that?

!SLIDE
# Not easily repeatable

!SLIDE
# Not consistent

!SLIDE
# Not portable

!SLIDE prettify
# "To err is human..."

