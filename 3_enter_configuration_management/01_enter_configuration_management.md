!SLIDE
# Configuration management

!SLIDE
# Chef

!SLIDE
# Puppet

!SLIDE
# Why we use Puppet

!SLIDE prettify
# Why it doesn't matter

!SLIDE
# A Puppet primer

!SLIDE

    @@@ ruby
    user { 'henry':
      ensure     => present,
      uid        => '507',
      gid        => 'admin',
      shell      => '/bin/zsh',
      home       => '/home/henry',
      managehome => true,
    }

!SLIDE

    @@@ sh
    $ puppet apply henry.pp
    # notice: /Stage[main]//User[henry]/ensure:
    # created

    $ puppet apply henry.pp

!SLIDE

    @@@ sh
    $ sudo chsh henry
    # Changing shell for henry.
    # New shell [/bin/zsh]: /bin/bash
    # Shell changed.

    $ puppet apply henry.pp
    # notice: /Stage[main]//User[henry]/shell:
    # shell changed '/bin/bash' to '/bin/zsh'

!SLIDE

    @@@ ruby
    package { 'openssh-server':
      ensure => installed,
    }

    file { '/etc/sudoers':
      ensure => present,
    }

    service { 'sshd':
      ensure => running,
    }

!SLIDE
# Puppet Agent

!SLIDE
# The Puppet Master

