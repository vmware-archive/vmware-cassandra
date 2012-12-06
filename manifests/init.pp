# Class: cassandra
#
# This class installs Apache Cassandra
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class cassandra (
  $version = $cassandra::params::version,
  $cassandra_home = $cassandra::params::cassandra_home,
  $source_file = $cassandra::params::source_file,
  $source = $cassandra::params::source
) inherits cassandra::params{

    file { "/var/tmp/$source_file":
      ensure  => present,
      source  => "${source}/${source_file}",
    }

    exec { 'install_cassandra':
      command => "tar -xzf $source_file -C /opt",
      cwd     => '/var/tmp',
      path    => $path,
      creates => "/opt/apache-cassandra-${version}",
      require => File["/var/tmp/$source_file"],
    }

    file { $cassandra_home:
      ensure  => link,
      target  => "/opt/apache-cassandra-${version}",
      require => Exec['install_cassandra'],
    }

    file {[
      '/var/lib/cassandra',
      '/var/lib/cassandra/data',
      '/var/lib/cassandra/commitlog',
      '/var/lib/cassandra/saved_caches',
      '/var/log/cassandra'
    ]:
      ensure  => directory,
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      require => File[$cassandra_home]
    }

    file { '/usr/local/bin/cassandra-cli':
      ensure  => link,
      target  => "${cassandra_home}/bin/cassandra-cli",
      require => File[$cassandra_home]
    }

    file { '/etc/init.d/cassandra':
      ensure  => present,
      mode    => '0755',
      owner   => 'root',
      group   => 'root',
      content => template("cassandra/cassandra_init.erb"),
      require => File[$cassandra_home]
    }

    class { 'cassandra::service':
      ensure  => running,
      require => File['/etc/init.d/cassandra']
    }

}