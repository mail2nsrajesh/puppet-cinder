require 'spec_helper'

describe 'cinder::volume::dellsc_iscsi' do

  let :params do
  {
      :san_ip                => '172.23.8.101',
      :san_login             => 'Admin',
      :san_password          => '12345',
      :iscsi_ip_address      => '192.168.0.20',
      :dell_sc_ssn           => '64720',
  }
  end

  let :default_params do
  {
      :dell_sc_api_port       => '<SERVICE DEFAULT>',
      :dell_sc_server_folder  => 'srv',
      :dell_sc_verify_cert    => '<SERVICE DEFAULT>',
      :dell_sc_volume_folder  => 'vol',
      :iscsi_port             => '<SERVICE DEFAULT>',
      :excluded_domain_ip     => '<SERVICE DEFAULT>',
      :secondary_san_ip       => '<SERVICE DEFAULT>',
      :secondary_san_login    => '<SERVICE DEFAULT>',
      :secondary_san_password => '<SERVICE DEFAULT>',
      :secondary_sc_api_port  => '<SERVICE DEFAULT>',
  }
  end

  let :facts do
    OSDefaults.get_facts({})
  end

   shared_examples_for 'dellsc_iscsi volume driver' do
    let :params_hash do
      default_params.merge(params)
    end

    it 'configures cinder volume driver' do
      params_hash.each_pair do |config,value|
        is_expected.to contain_cinder_config("DEFAULT/#{config}").with_value( value )
      end
    end

    it 'marks san_password as secret' do
      is_expected.to contain_cinder_config('DEFAULT/san_password').with_secret( true )
    end

  end

  context 'with parameters' do
    it_configures 'dellsc_iscsi volume driver'
  end

  context 'dellsc_iscsi volume driver with additional configuration' do
    before :each do
      params.merge!({:extra_options => { 'dellsc_iscsi_backend/param1' => {'value' => 'value1'}}})
    end

    it 'configure dellsc_iscsi volume with additional configuration' do
      is_expected.to contain_cinder__backend__dellsc_iscsi('DEFAULT').with({
        :extra_options => {'dellsc_iscsi_backend/param1' => {'value' => 'value1'}}
      })
    end

  end
end
