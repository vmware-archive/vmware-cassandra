service { 'iptables':
  ensure => stopped,
  enable => false,
  before => Class['cassandra'],
}

include cassandra
