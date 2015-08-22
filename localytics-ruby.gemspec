# encoding: utf-8

Gem::Specification.new do |s|
  s.name              = 'localytics-ruby'
  s.version           = '0.0.1'
  s.summary           = 'Ruby wrapper for Localytics API'
  s.description       = 'API to interact with Localytics\nhttps://localytics.com/'
  s.authors           = ['Tobuy development team', 'Marcos Chicote']
  s.email             = ['support@tob.uy']
  s.homepage          = 'https://tob.uy/'
  s.files             = []

  s.license           = 'MIT'
  s.add_dependency('rest-client', '~> 1.7')
  s.add_development_dependency('cutest', '~> 1.2')
  s.add_development_dependency('mocha', '~> 1.1')

  s.files = %w{
    lib/localytics.rb
    lib/localytics-ruby.rb
    lib/localytics/resources.rb
    lib/localytics/operations.rb
  }

  s.test_files = %w{
    test/localytics_test.rb
    test/test_helper.rb
  }

end