# frozen_string_literal: true

require './lib/burner/version'

Gem::Specification.new do |s|
  s.name        = 'burner'
  s.version     = Burner::VERSION
  s.summary     = 'Declarative and extendable processing pipeline'

  s.description = <<-DESCRIPTION
    This library serves as the backbone for a configurable processing engine.  It allows you to organize your code into jobs, then stitch those jobs together as steps.
  DESCRIPTION

  s.authors     = ['Matthew Ruggio']
  s.email       = ['mruggio@bluemarblepayroll.com']
  s.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.bindir      = 'exe'
  s.executables = %w[burner]
  s.homepage    = 'https://github.com/bluemarblepayroll/burner'
  s.license     = 'MIT'
  s.metadata    = {
    'bug_tracker_uri' => 'https://github.com/bluemarblepayroll/burner/issues',
    'changelog_uri' => 'https://github.com/bluemarblepayroll/burner/blob/master/CHANGELOG.md',
    'documentation_uri' => 'https://www.rubydoc.info/gems/burner',
    'homepage_uri' => s.homepage,
    'source_code_uri' => s.homepage
  }

  s.required_ruby_version = '>= 2.5'

  s.add_dependency('acts_as_hashable', '~>1.2')
  s.add_dependency('hashematics', '~>1.1')
  s.add_dependency('hash_math', '~>1.2')
  s.add_dependency('objectable', '~>1.0')
  s.add_dependency('realize', '~>1.3')
  s.add_dependency('stringento', '~>2.1')

  s.add_development_dependency('guard-rspec', '~>4.7')
  s.add_development_dependency('pry', '~>0')
  s.add_development_dependency('rake', '~> 13')
  s.add_development_dependency('rspec', '~> 3.8')
  s.add_development_dependency('rubocop', '~>0.90.0')
  s.add_development_dependency('simplecov', '~>0.18.5')
  s.add_development_dependency('simplecov-console', '~>0.7.0')
end
