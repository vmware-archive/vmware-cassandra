# Class: cassandra::params
#
# Default parameters for Cassandra installation
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class cassandra::params {
  $version = '1.1.7'
  $source_file = "apache-cassandra-${version}-bin.tar.gz"
  $source = "puppet:///modules/cassandra"
  $cassandra_home = "/opt/cassandra"
}