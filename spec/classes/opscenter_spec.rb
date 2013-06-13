require 'spec_helper'

describe 'cassandra::opscenter' do
  context 'default' do
    it do
      should contain_yumrepo 'Datastax'

      should contain_package 'opscenter-free'
      should contain_file '/opt/opcenter'
      should contain_file('/etc/opscenter/opscenterd.conf').
        with_content(%r[port = 8888])
      should contain_file('/etc/opscenter/opscenterd.conf').
        with_content(%r[#ssl_keyfile = /var/lib/opscenter/ssl/opscenter.key])

      should contain_staging__deploy 'agent.tar.gz'
      should contain_service 'opscenterd'
    end
  end

  context 'alternate port' do
    let(:params){{
      :webserver_port => '8889',
    }}

    it do
      should contain_file('/etc/opscenter/opscenterd.conf').
        with_content(%r[port = 8889])
    end
  end

  context 'ssl enabled' do
    let(:params){{
      :ssl => 'true',
    }}
    it do
      should contain_file('/etc/opscenter/opscenterd.conf').
        with_content(%r[ssl_keyfile = /var/lib/opscenter/ssl/opscenter.key])
      should contain_file('/etc/opscenter/opscenterd.conf').
        with_content(%r[ssl_certfile = /var/lib/opscenter/ssl/opscenter.pem])
      should contain_file('/etc/opscenter/opscenterd.conf').
        with_content(%r[ssl_port = 8443])
    end
  end
end
