# Class: cassandra::params
#
#   Default parameters for Cassandra installation
#
class cassandra::params {
  $version        = '1.2.9'
  $source         = 'http://archive.apache.org/dist/cassandra'
  $cassandra_home = '/opt/cassandra'
}
