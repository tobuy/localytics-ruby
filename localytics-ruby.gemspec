# encoding: utf-8

Gem::Specification.new do |s|
  s.name              = 'localytics-ruby'
  s.version           = '0.0.7'
  s.summary           = 'Ruby wrapper for Localytics API'
  s.description       = 'API to interact with Localytics https://localytics.com/'
  s.authors           = ['Tobuy development team', 'Marcos Chicote']
  s.email             = ['support@tob.uy']
  s.homepage          = 'https://github.com/tobuy/localytics-ruby'
  s.license           = 'MIT'

  s.files      = Dir["lib/**/*"] + ["LICENSE", "README.md"]
  s.test_files = Dir["test/*"]

  s.add_dependency('rest-client', '~> 2.0')
  s.add_development_dependency('cutest', '~> 1.2')
  s.add_development_dependency('mocha', '1.1')
end
