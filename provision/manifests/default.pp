#
# site.pp - defines defaults for vagrant provisioning
#

# use run stages for minor vagrant environment fixes
stage { 'pre': before => Stage['main'] }

class { 'repos':   stage => 'pre' }
class { 'vagrant': stage => 'pre' }

class { 'puppet':
  ensure => '2.7.21-1puppetlabs1',
}
class { 'networking': }

if $hostname == 'puppet' {
  class { 'puppet::server':
    require => Class['puppet'],
  }
}
