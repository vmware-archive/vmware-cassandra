class { 'staging':
  path => '/var/tmp',
} ->

staging::file { 'apache-cassandra-1.1.7-bin.tar.gz':
  source => 'http://archive.apache.org/dist/cassandra/1.1.7/apache-cassandra-1.1.7-bin.tar.gz',
} ->

class { 'cassandra':
  source => '/var/tmp',
}
