# Class: cassandra::service
#
# This class manages the Cassandra Service
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class cassandra::service(
  $ensure = 'running',
) {

  validate_re($ensure, '^(running|stopped)$')

  if $ensure == 'running' {
    $ensure_real = running
    $enable_real = true
  } else {
    $ensure_real = stopped
    $enable_real = false
  }

  service {'cassandra':
    ensure     => $ensure_real,
    enable     => $enable_real,
    hasrestart => true,
    hasstatus  => true,
    require    => [ File['/etc/init.d/cassandra'], File['/opt/cassandra/conf/cassandra.yaml'] ]
  }
}
