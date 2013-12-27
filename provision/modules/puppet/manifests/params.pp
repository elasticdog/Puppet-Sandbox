# == Class: puppet::params
#
# This class manages the Puppet parameters.
#
# === Parameters
#
# === Actions
#
# === Requires
#
# === Sample Usage
#
# This class file is not called directly.
#
class puppet::params {

  $server_ensure = 'latest'

  case $::osfamily {
    'redhat': {
      $client_ensure = 'latest'
      $server_package_name = 'puppet-server'
    }
    'debian': {
      $client_ensure = 'latest'
      $server_package_name = 'puppetmaster'
    }

    'windows': {
      $client_ensure = 'present'
      $server_package_name = undef
      warning ("Puppet master is not currently supported by Puppet Labs on ${::operatingsystem}")
    }

    default: {
      fail("Module 'puppet' is not currently supported by Puppet Sandbox on ${::operatingsystem}")
    }
  }

}
