# == Class: repository::server::yum
#
#
class repository::server-yum {

# Gimme some apache!
  package { 'httpd':
    ensure => 'present';
  }

  package { 'createrepo':
    ensure => 'present',
    notify  => Exec["yum_createrepo"],
  }

  file { 'yum-repo.conf':
    ensure  => present,
    path    => '/etc/httpd/conf.d/yum-repo.conf',
    owner   => root,
    group   => root,
    mode    => '0644',
    replace => true,
    source  => 'puppet:///modules/repository/yum-repo.conf',
  }


  file { '/vagrant/repository/yum':    
    path    => '/vagrant/repository/yum',
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0644',
    recurse => true,
    notify  => Exec['yum_createrepo'],
  }

  file { 'index.html':
    ensure  => present,
    path    => '/vagrant/repository/yum/index.html',
    owner   => root,
    group   => root,
    mode    => '0644',
    replace => true,
    source  => 'puppet:///modules/repository/index.html',
  }

  exec { 'yum_createrepo':
    command     => '/usr/bin/createrepo /vagrant/repository/yum',
    refreshonly => true,
  }

  service { "httpd":
    ensure => "running",
    subscribe => File["yum-repo.conf"], 
  }

}

