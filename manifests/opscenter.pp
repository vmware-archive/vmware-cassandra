# class: installs opscenter
class cassandra::opscenter (
  $webserver_port = '8888',
  $ssl            = false,
  $public_key     = '/var/lib/opscenter/ssl/opscenter.pem',
  $private_key    = '/var/lib/opscenter/ssl/opscenter.key',
  $ssl_port       = '8443'
) {

  yumrepo { 'Datastax':
    name     => 'Datastax',
    baseurl  => 'http://rpm.datastax.com/community',
    descr    => 'DataStax Repository',
    enabled  => 1,
    gpgcheck => 0,
  }

  package { [
    'opscenter-free',
  ]:
    ensure  => latest,
    require => Yumrepo[ 'Datastax' ],
  }

  file { '/etc/opscenter/opscenterd.conf':
    ensure  => present,
    mode    => '0755',
    owner   => 'opscenter',
    group   => 'opscenter',
    content => template('cassandra/opscenter_conf.erb'),
    require => Package['opscenter-free'],
    notify  => Service['opscenterd'],
  }

  file { '/opt/opscenter':
    ensure => directory,
    owner  => '0',
    group  => '0',
    mode   => '0755',
  }

  service { 'opscenterd':
    ensure  => 'running',
    enable  => true,
    require => [ Package['opscenter-free'], File['/etc/opscenter/opscenterd.conf'] ],
  }

  staging::deploy { 'agent.tar.gz':
    target  => '/opt/opscenter',
    creates => '/opt/opscenter/agent',
    source  => '/usr/share/opscenter/agent.tar.gz',
    require => [ Package['opscenter-free'], File['/opt/opscenter'] ]
  }

  exec { "/opt/opscenter/agent/bin/install_agent.sh /opt/opscenter/agent/opscenter-agent.rpm ${::ipaddress}":
    refreshonly => true,
    path        => $::path,
    subscribe   => Staging::Extract['agent.tar.gz'],
  }
}
