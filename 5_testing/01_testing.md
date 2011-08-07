!SLIDE prettify
# "With great power..."

!SLIDE
# Testing

!SLIDE
#`$ puppet apply --noop`

!SLIDE center no-shadow
![vagrant](vagrant_chilling.png)

# Vagrant

!SLIDE smaller

    @@@ ruby
    config.vm.provision :puppet do |puppet|
      puppet.module_path    = "modules"
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "mcp.pp"
    end

!SLIDE incremental commandline smaller

    $ bundle exec vagrant up
    [default] Box natty was not found. Fetching box...
    [default] Downloading with Vagrant::Downloaders::HTTP...
    [default] Downloading box: http://mudge.name/downloads...
    [default] Extracting box...
    [default] Verifying box...
    [default] Cleaning up downloaded box...
    [default] Importing base box 'natty'...
    [default] Matching MAC address for NAT networking...
    [default] Clearing any previously set forwarded ports...
    [default] Forwarding ports...
    [default] -- ssh: 22 => 2222 (adapter 1)
    [default] Creating shared folders metadata...
    [default] Running any VM customizations...
    [default] Booting VM...
    [default] Waiting for VM to boot. This can take a few minutes.

!SLIDE incremental commandline smaller

    $ bundle exec vagrant provision
    [default] Running provisioner: Vagrant::Provisioners::Puppet...
    [default] Running Puppet with mcp.pp...

!SLIDE
# Cucumber-Puppet

!SLIDE smaller

    Feature: General catalog policy
      In order to ensure a host's catalog
      As a manifest developer
      I want all catalogs to obey some general rules

      Scenario Outline: Compile and verify catalog
        Given a node specified by "features/yaml/eg.yml"
        When I compile its catalog
        Then compilation should succeed
        And all resource dependencies should resolve

        Examples:
          | hostname  |
          | localhost |
