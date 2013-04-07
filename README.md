Description
===========

Puppet Sandbox is a multi-VM [Vagrant](http://vagrantup.com/)-based Puppet
development environment used for creating and testing new modules outside
of your production environment. It is prefered over the upstream [Learning
Puppet VM](http://info.puppetlabs.com/download-learning-puppet-VM.html) as
it gives you more flexibility and allows you to use your own local editing
environment and tools.

Puppet Sandbox will set up three separate virtual machines:

* _puppet.example.com_  - the Puppet master server
* _client1.example.com_ - the first Puppet client machine
* _client2.example.com_ - the second Puppet client machine
* _fpm.example.com_     - package building machine

These VMs can be used in conjunction to segregate and test your modules
based on node roles, Puppet environments, etc. You can even test modules
on different Linux distributions or release versions to better match your
production infrastructure.

**Check out the [Puppet Sandbox Demonstration](http://vimeo.com/elasticdog/puppet-sandbox-demo)
screencast for a brief overview of the project.**

Requirements
============

To use Puppet Sandbox, you must have the following items installed and working:

* [VirtualBox](https://www.virtualbox.org/)
* [Vagrant 1.1+](http://vagrantup.com/)

Puppet Sandbox has been designed for and tested with Vagrant base boxes running:

* CentOS 6.3
* CentOS 5.8
* Ubuntu 12.04 - Precise Pangolin
* Ubuntu 10.04 - Lucid Lynx

...although it may work just fine with other distributions/versions.

Usage
=====

Make sure you have a compatible Vagrant base box (if you don't have one
already, it will download a 64-bit Ubuntu 12.04 box for you), and then you
should be good to clone this repo and go:

    $ vagrant box list
    precise64
    $ git clone git://github.com/elasticdog/puppet-sandbox.git
    $ cd puppet-sandbox/

If you want a CentOS base box to work from, I highly recommend the boxes
published by Jan Vansteenkiste: http://packages.vstone.eu/vagrant-boxes/
if using other CentOS boxes watch out for iptables being turned on by default.

The Vagrantfile is a symlink to either Vagrantfile.precise64 or Vagrantfile.centos63.

Initial Startup
---------------

To bring up the Puppet Sandbox environment, issue the following command:

    $ vagrant up

The following tasks will be handled automatically:

1. The Puppet server daemon will be installed and enabled on the master
   machine.
2. The Puppet client agent will be installed and enabled on all three machines.
3. A host-only network will be set up with all machines knowing how to
   communicate with each other.
4. All client certificate requests will be automatically signed by the master
   server.
5. The master server will utilize the `nodes.pp` file and `modules/` directory
   that exist **outside of the VMs** (in your puppet-sandbox Git working
   directory) by utilizing VirtualBox's shared folder feature.

All of this is handled using Vagrant's provisioning capabilities and is
controlled by the manifests under the `provision/` directory. In theory, you
should never have to touch any of that code directly unless you're working to
improve Puppet Sandbox.

If you wish to change the domain name of the VMs (it defaults to
_example.com_), edit the "domain" variable at the top of `Vagrantfile` and
reload the machines:

    $ vim Vagrantfile
    $ vagrant reload

Developing New Modules
----------------------

To start developing a new Puppet module, just create the standard module
structure under `modules/` in your puppet-sandbox Git working directory (an
example "helloworld" module should exist there already). This directory is
automatically in the Puppet master server's _modulepath_, and any changes will
be picked up immediately.

    $ mkdir -p modules/users/manifests
    $ vim modules/users/manifests/init.pp

To have your module actually applied to one or more of the nodes, edit the
`nodes.pp` file and include your classes...that's it!

Check Your Handiwork
--------------------

To log on to the virtual machines and see the result of your applied Puppet
modules, just use standard [Vagrant Multi-VM
Environment](http://vagrantup.com/docs/multivm.html) commands, and provide the
proper VM name (`master`, `client1`, or `client2`):

    $ vagrant ssh client1

If you don't want to wait for the standard 30-minutes between Puppet runs by
the agent daemon, you can easily force a manual run:

    [vagrant@client1 ~]$ sudo puppet agent --test


Package Repositories
--------------------

A local YUM repo `sandbox` is configured on the puppet server.     Copy RPM files into `/vagrant/packages/rpm` and then run `vagrant provision puppet` to refresh the repo.    Currently only supports RPM/YUM but will add APT support some time soon.

Building Packages
-----------------

FPM is installed on the fpm host.   This is an excellent tool for building OS packages where writing specfiles gets painful.    FPM allows you to create RPM or APT packages from source,  or from a directory with all the apps installed.    Check the example redis or elasticsearch scripts on the FPM system under /tmp/ for examples of building packages using FPM.    Saving the resultant RPM to `/vagrant/packages/rpm` and run `vagrant provision puppet` will make it immediately available to client1,client2 for installation. 

Example Package Building and Usage
----------------------------------

    $ vagrant up puppet fpm client1
    $ vagrant ssh fpm
    [vagrant@fpm ~]$ sudo /tmp/redis-rpm.sh
    ...
    ...
    [vagrant@fpm ~]$ exit
    $ vagrant provision puppet
    $ vagrant ssh client1
    [vagrant@client1 ~]$ sudo yum clean all
    [vagrant@client1 ~]$ sudo yum -y install redis
    [vagrant@client1 ~]$ sudo service redis-server start
    [vagrant@client1 ~]$ redis-cli ping
    PONG
    [vagrant@client1 ~]$





License
=======

Puppet Sandbox is provided under the terms of [The MIT
License](http://www.opensource.org/licenses/MIT).

Copyright &copy; 2012, [Aaron Bull Schaefer](mailto:aaron@elasticdog.com).
