#yum -y install ruby rubygems ruby-devel make gcc rpm-build git
# gem install fpm

class fpm::centos {
  package { 'ruby-devel':
    ensure => 'present',
  }
  package { 'rubygems':
    ensure => 'present',
  }
  package { 'make':
    ensure => 'present',
  }
  package { 'gcc':
    ensure => 'present',
  }
  package { 'rpm-build':
    ensure => 'present',
  }
  package { 'git':
    ensure => 'present',
  }
  package { 'fpm':
    ensure => 'present',
    provider => 'gem',
    require  => [ Package["rubygems"], Package["ruby-devel"] ],
  }
}