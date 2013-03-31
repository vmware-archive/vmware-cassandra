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

  service { "opscenterd":
    ensure  => "running",
    enable  => "true",
    subscribe => File['/etc/opscenter/opscenterd.conf'],
  }

}