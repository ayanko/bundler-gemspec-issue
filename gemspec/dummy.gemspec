Gem::Specification.new do |spec|
  spec.name = 'dummy'
  spec.version = '0'
  spec.authors = 'Developer'
  spec.email = 'developer@example.com'
  spec.summary = 'Dummy Gem'

  spec.add_dependency 'i18n', '1.8.5'

  if ENV['WITH_NEW_GEM']
    spec.add_dependency 'deep_merge', '1.2.1'
  end
end
