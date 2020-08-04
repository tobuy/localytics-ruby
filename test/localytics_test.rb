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

test 'operation show' do |mock|
  mock.expects(:get).once.with('https://profile.localytics.com/v1/profiles/123', {}).returns(test_response(test_profile))
  profile = Localytics::Profile.show 123
  assert_equal 'Tester', profile[:attributes]['$first_name'.to_sym]
end

test 'operation show in app' do |mock|
  mock.expects(:get).once.with('https://profile.localytics.com/v1/apps/app_id/profiles/123', {}).returns(test_response(test_profile))
  profile = Localytics::Profile.show 123, 'app_id'
  assert_equal 'Tester', profile[:attributes]['$first_name'.to_sym]
end

test 'operation show in app global' do |mock|
  mock.expects(:get).once.with('https://profile.localytics.com/v1/apps/app_id/profiles/123', {}).returns(test_response(test_profile))
  Localytics::Profile.app_id = 'app_id'
  profile = Localytics::Profile.show 123
  assert_equal 'Tester', profile[:attributes]['$first_name'.to_sym]
  Localytics::Profile.app_id = nil
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

test 'operation profiles' do |mock|
  mock.expects(:get).once.with('https://profile.localytics.com/v1/customers/Isa', {}).returns(test_response(test_profiles))
  profiles = Localytics::Profile.profiles 'Isa'
  assert_equal 'Isa', profiles[:id]
  assert_equal 'Isa', profiles[:profiles][0][:attributes][:name]
end

test 'operation profiles' do |mock|
  mock.expects(:get).once.with('https://profile.localytics.com/v1/customers?email=isa@localytics.com', {}).returns(test_response(test_profiles))
  profiles = Localytics::Profile.profiles_by_email 'isa@localytics.com'
  assert_equal 'Isa', profiles[:id]
  assert_equal 'Isa', profiles[:profiles][0][:attributes][:name]
end

test 'send push' do |mock|
  mock.expects(:post).once.with('https://messaging.localytics.com/v2/push/app_id', anything).returns(test_response({}, 200))
  Localytics::Push.push_to_customers [{alert: 'message', target: 1}], 'app_id'
end

test 'show apps' do |mock|
  mock.expects(:get).once.with('https://api.localytics.com/v1/apps', {}).returns(test_response(test_show_apps, 200))
  apps = Localytics::App.show_apps
  assert_equal 'App Name', apps[:_embedded][:apps][0][:name]
end

test 'show app' do |mock|
  mock.expects(:get).once.with('https://api.localytics.com/v1/apps/umdois', {}).returns(test_response(test_show_app, 200))
  app = Localytics::App.show_app('umdois')
  assert_equal 'App Name', app[:name]
end

test 'show app attributes' do |mock|
  mock.expects(:get).once.with('https://api.localytics.com/v1/apps/umdois/attributes', {}).returns(test_response(test_apps_attributes, 200))
  events = Localytics::App.app_attributes('umdois')
  assert_equal 'Clicked Link', events[:events][0][:event_name]
end

test 'send event' do |mock|
  mock.expects(:post).once.with('https://analytics.localytics.com/events/v1/uploads', anything).returns(test_response({}, 202))
  response = Localytics::Event.send('app_id', 111111, 'event_name')
  assert(response.empty?)
end
