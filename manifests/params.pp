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
  $version        = '1.2.4'
  $source         = 'puppet:///modules/cassandra'
  $cassandra_home = '/opt/cassandra'
}
