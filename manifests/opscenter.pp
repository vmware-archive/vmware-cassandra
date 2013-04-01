class cassandra::opscenter {

  yumrepo { "Datastax":
    name     => "Datastax",
    baseurl  => "http://rpm.datastax.com/community",
    descr    => "DataStax Repository",
    enabled  => 1,
    gpgcheck => 0,
  }

  package { [
    "opscenter-free",
  ]:
    ensure => latest,
    require => Yumrepo[ "Datastax" ],
  }

  file { "/etc/opscenter/opscenterd.conf":
    ensure  => present,
    mode    => '0755',
    owner   => 'opscenter',
    group   => 'opscenter',
    content => template('cassandra/opscenter_conf.erb'),
    require => Package["opscenter-free"],
    notify  => Service["opscenterd"],
  }

  file { "/opt/opcenter":
    ensure => directory,
    owner  => '0',
    group  => '0',
    mode   => '0755',
  }

  service { "opscenterd":
    ensure  => "running",
    enable  => "true",
    require => [ Package["opscenter-free"], File["/etc/opscenter/opscenterd.conf"] ],
  }

  staging::deploy { "agent.tar.gz":
    target  => '/opt/opcenter',
    creates => "/opt/opcenter/agent",
    source  => "/usr/share/opscenter/agent.tar.gz",
    require => [ Package["opscenter-free"], File["/opt/opcenter"] ]
  }

  exec { "/opt/agent/bin/install_agent.sh /opt/agent/opscenter-agent.rpm $ipaddress":
    refreshonly => true,
    path        => ["/usr/bin", "/usr/sbin"],
    subscribe   => Staging::Extract["agent.tar.gz"],
  }
}