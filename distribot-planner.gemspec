Gem::Specification.new do |spec|
  spec.name        = 'distribot-planner'
  spec.version     = '0.1.3'
  spec.authors     = ['John Drago']
  spec.email       = 'jdrago.999@gmail.com'
  spec.homepage    = 'https://github.com/distribot/distribot-planner'
  spec.summary     = 'A planning extension for Distribot handlers.'
  spec.description = 'A planning extension for Distribot handlers.'
  spec.required_rubygems_version = '>= 1.3.6'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'shoulda-matchers'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'simplecov'
end
