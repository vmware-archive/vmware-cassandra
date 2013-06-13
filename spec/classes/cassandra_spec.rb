require 'spec_helper'

describe 'cassandra' do
  context 'default' do
    it do
      should include_class 'java'
      should include_class 'staging'

      should contain_staging__deploy('apache-cassandra-1.2.4-bin.tar.gz').
        with_source('http://archive.apache.org/dist/cassandra/1.2.4/apache-cassandra-1.2.4-bin.tar.gz')

      [
        '/opt/cassandra',
        '/var/lib/cassandra',
        '/var/lib/cassandra/data',
        '/var/lib/cassandra/commitlog',
        '/var/lib/cassandra/saved_caches',
        '/var/log/cassandra'
      ].each do |f|
        should contain_file f
      end

      should contain_file('/usr/local/bin/cassandra-cli').
        with_target('/opt/cassandra/bin/cassandra-cli')
      should contain_file('/etc/init.d/cassandra').
        with_content(%r[progbin="/opt/cassandra/bin"])
      should contain_file '/opt/cassandra/conf/cassandra.yaml'

      should contain_service 'cassandra'
    end
  end

  context 'alternate cassandra dir' do
    let(:params){{
      :cassandra_home => '/var/opt/cassandra',
    }}

    it do
      # This is busted, we can only deploy to /opt.
      #should contain_staging__deploy('apache-cassandra-1.2.4-bin.tar.gz').
      #  with_target('/var/opt/cassandra')

      [
        '/var/opt/cassandra',
        '/var/lib/cassandra',
        '/var/lib/cassandra/data',
        '/var/lib/cassandra/commitlog',
        '/var/lib/cassandra/saved_caches',
        '/var/log/cassandra'
      ].each do |f|
        should contain_file f
      end

      should contain_file('/usr/local/bin/cassandra-cli').
        with_target('/var/opt/cassandra/bin/cassandra-cli')
      should contain_file('/etc/init.d/cassandra').
        with_content(%r[progbin="/var/opt/cassandra/bin"])
      should contain_file '/var/opt/cassandra/conf/cassandra.yaml'
    end
  end

  context 'alternate version' do
    let(:params){{
      :version => '2.0.0',
    }}

    it do
      should contain_staging__deploy('apache-cassandra-2.0.0-bin.tar.gz').
        with_source('http://archive.apache.org/dist/cassandra/2.0.0/apache-cassandra-2.0.0-bin.tar.gz')
    end
  end

  context 'ssl enabled' do
    let(:params){{
      :ssl => true,
    }}

    it do
      should contain_file('/opt/cassandra/conf/cassandra.yaml').
        with_content(%r[keystore: conf/.keystore])
    end
  end
end
