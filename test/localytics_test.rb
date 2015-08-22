require File.expand_path('../lib/localytics', File.dirname(__FILE__))
require File.expand_path('test_helper', File.dirname(__FILE__))

require 'cutest'
require 'mocha/api'
include Mocha::API

prepare do
  Localytics.api_key = '1234'
  Localytics.api_secret = '1234'
end

setup do
  Localytics.mock_rest_client = mock
end

test 'api_base url' do
  assert_equal 'https://profile.localytics.com/v1/profiles', Localytics::Profile.api_base
end

test 'resource url' do
  assert_equal '', Localytics::Profile.url
  assert_equal '/123', Localytics::Profile.url(123)
end

test 'operation show' do |mock|
  mock.expects(:get).once.with('https://profile.localytics.com/v1/profiles/123', {}).returns(test_response(test_profile))
  profile = Localytics::Profile.show 123
  assert_equal 'Tester', profile[:attributes]['$first_name'.to_sym]
end

test 'operation create' do |mock|
  mock.expects(:post).once.with('https://profile.localytics.com/v1/profiles/1234', anything).returns(test_response(test_profile))
  profile = Localytics::Profile.create 1234, profile_params
  assert_equal 'Tester', profile[:attributes]['$first_name'.to_sym]
end

test 'operation update' do |mock|
  mock.expects(:patch).once.with('https://profile.localytics.com/v1/profiles/1234', anything).returns(test_response(test_profile))
  profile = Localytics::Profile.update 1234, profile_params
  assert_equal 'Tester', profile[:attributes]['$first_name'.to_sym]
end

test 'operation delete' do |mock|
  mock.expects(:delete).once.with('https://profile.localytics.com/v1/profiles/1234').returns(test_response({}, 204))
  profile = Localytics::Profile.delete 1234
  assert(profile.empty?)
end
