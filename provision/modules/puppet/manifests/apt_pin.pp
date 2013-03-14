# == Class: puppet::apt_pin
#
# This class pins the puppet package versions so installing specific versions
# of Puppet can work on Debian/Ubuntu hosts.
#
# === Parameters
#
# [*version*]
#   Which version that puppet packages should be pinned to.
#
class puppet::apt_pin(
  $version
) {
  file { 'puppet.pref':
    path    => '/etc/apt/preferences.d/puppet.pref',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('puppet/puppet_apt_pin.pref.erb')
  }

  # Ensure the pinning file exists before packages are installed
  Class['puppet::apt_pin'] -> Package['puppet']
  if defined(Package['puppetmaster']) {
    Class['puppet::apt_pin'] -> Package['puppetmaster']
  }
}
