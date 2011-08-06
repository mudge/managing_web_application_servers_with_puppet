!SLIDE
# Configuration management

!SLIDE
# What is it?

!SLIDE prettify
# "Infrastructure as code."

!SLIDE center
![chef](chef.png =300x)

!SLIDE center
![puppet](puppet.png =x300)

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
      gid        => 'staff',
      shell      => '/bin/zsh',
      home       => '/home/henry',
      managehome => true,
    }

!SLIDE incremental commandline

    $ sudo puppet apply henry.pp
    notice:
    /Stage[main]//User[henry]/ensure: created
    notice: Finished catalog run in 0.25 seconds

    $ grep henry /etc/passwd
    henry:x:507:50::/home/henry:/bin/zsh

!SLIDE incremental commandline

    $ sudo chsh henry
    Changing shell for henry.
    New shell [/bin/zsh]: /bin/bash
    Shell changed.

    $ sudo puppet apply henry.pp
    notice:
    /Stage[main]//User[henry]/shell:
    shell changed '/bin/bash' to '/bin/zsh'

!SLIDE
# The Trifecta

!SLIDE

    @@@ ruby
    package { 'openssh-server':
      ensure => installed,
    }

!SLIDE

    @@@ ruby
    file { '/etc/sudoers':
      ensure => present,
    }

!SLIDE

    @@@ ruby
    service { 'sshd':
      ensure => running,
    }

!SLIDE
# Puppet Master and Agent

