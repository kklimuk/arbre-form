
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arbre/form/version'

Gem::Specification.new do |spec|
  spec.name          = 'arbre-form'
  spec.version       = Arbre::Form::VERSION
  spec.authors       = ['Kirill Klimuk']
  spec.email         = ['kklimuk@gmail.com']

  spec.summary       = %q{Implements Arbre components for forms}
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'arbre', '~> 1.1'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
