!SLIDE prettify
# A typical Rails application
## "everyman"

!SLIDE incremental commandline

    $ ls everyman
    Capfile      config       log
    Gemfile      config.ru    public
    Gemfile.lock db           script
    README       doc          spec
    Rakefile     features     tmp
    app          lib          vendor

!SLIDE prettify
# Let's prepare a server

!SLIDE incremental commandline

    $ ssh mudge@server1
    Last login: Mon Aug  1 21:08:06 2011
    from 123-45-67-89.

!SLIDE
# Users

!SLIDE incremental commandline

    $ adduser -h
    adduser [--home DIR] [--shell SHELL]
    [--no-create-home] [--uid ID] [--firstuid ID]
    [--lastuid ID] [--gecos GECOS]
    [--ingroup GROUP | --gid ID]
    [--disabled-password] [--disabled-login]
    [--encrypt-home] USER
       Add a normal user

!SLIDE incremental commandline

    $ sudo adduser everyman
    Adding user `everyman' ...
    Adding new group `everyman' (1002) ...
    Adding new user `everyman' (1001) with group
    `everyman' ...
    Creating home directory `/home/everyman' ...
    Copying files from `/etc/skel' ...

!SLIDE
# SSH Keys

!SLIDE incremental commandline

    $ sudo -s
    $ mkdir -m 700 ~everyman/.ssh
    $ vi ~everyman/.ssh/authorized_keys
    $ chmod 600 ~everyman/.ssh/authorized_keys
    $ chown -R everyman: ~everyman/.ssh

!SLIDE
# Directories

!SLIDE incremental commandline

    $ sudo -s
    $ mkdir -p ~everyman/everyman/shared/config
    $ chown -R everyman: ~everyman/everyman

!SLIDE
# Sensitive configuration

!SLIDE incremental commandline

    $ sudo -s
    $ cd ~everyman/everyman/shared/config
    $ vi database.yml

!SLIDE
# RVM <span>&</span> Ruby

!SLIDE incremental commandline

    $ sudo -s
    $ apt-get install curl git-core subversion
    Reading package lists... Done
    Building dependency tree
    Reading state information... Done

!SLIDE incremental commandline

    $ sudo -s
    $ bash < <(curl -s https://rvm.beginrescu...
    Initialized empty Git repository in
    /usr/local/rvm/src/rvm/.git/
    remote: Counting objects: 5270, done.
    remote: Compressing objects: 100% (2516/2516),
    done.

!SLIDE incremental commandline

    $ apt-get install build-essential bison
    $ apt-get install openssl libreadline6
    $ apt-get install libreadline6-dev zlib1g
    $ apt-get install zlib1g-dev libssl-dev
    $ apt-get install libyaml-dev libsqlite3-0
    $ apt-get install libsqlite3-dev sqlite3
    $ apt-get install libxml2-dev libxslt-dev
    $ apt-get install autoconf libc6-dev
    $ apt-get install ncurses-dev

!SLIDE incremental commandline

    $ vi /usr/local/rvm/gemsets/global.gems
    $ ^vi^cat
    rake
    bundler

!SLIDE incremental commandline

    $ vi /etc/gemrc
    $ ^vi^cat
    install: --no-rdoc --no-ri
    update:  --no-rdoc --no-ri

!SLIDE incremental commandline

    $ source /usr/local/rvm/scripts/rvm
    $ rvm install 1.9.2
    Installing Ruby from source to:
    /usr/local/rvm/rubies/ruby-1.9.2-p290, this
    may take a while depending on your cpu(s)...

!SLIDE
# nginx <span>&</span> Passenger

!SLIDE incremental commandline

    $ rvm use 1.9.2
    Using /usr/local/rvm/gems/ruby-1.9.2-p290
    $ gem install passenger
    Fetching: fastthread-1.0.7.gem (100%)
    Building native extensions.  This could
    take a while...
    Fetching: daemon_controller-0.2.6.gem (100%)
    Fetching: rack-1.3.2.gem (100%)
    ...
    Successfully installed passenger-3.0.7

!SLIDE incremental commandline

    $ apt-get install libcurl4-openssl-dev
    Reading package lists... Done
    Building dependency tree
    Reading state information... Done
    $ passenger-install-nginx-module
    Welcome to the Phusion Passenger Nginx
    module installer, v3.0.7.

!SLIDE incremental commandline

    $ cd /opt/nginx/conf
    $ mkdir sites_available sites_enabled
    $ vi nginx.conf
    $ cd sites_available
    $ vi everyman.conf
    $ ln -s ../sites_{available,enabled}/every...

!SLIDE incremental commandline

    $ vi /etc/init.d/nginx
    $ chmod a+x /etc/init.d/nginx

!SLIDE
# Capistrano

!SLIDE incremental commandline

    $ cap deploy:setup
    $ cap deploy:check
    $ cap deploy:migrations

!SLIDE
# Manual labour

!SLIDE
# Not easily repeatable

!SLIDE
# Not portable

!SLIDE prettify
# "To err is human..."

!SLIDE prettify
# Where's my audit trail?
