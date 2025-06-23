# -*- encoding: utf-8 -*-
require_relative 'lib/rb-inotify/version'

Gem::Specification.new do |spec|
  spec.name     = 'rb-inotify'
  spec.version  = INotify::VERSION
  spec.platform = Gem::Platform::RUBY

  spec.summary     = 'A Ruby wrapper for Linux inotify, using FFI'
  spec.authors     = ['Natalie Weizenbaum', 'Samuel Williams']
  spec.email       = ['nex342@gmail.com', 'samuel.williams@oriontransfer.co.nz']
  spec.homepage    = 'https://github.com/guard/rb-inotify'
  spec.licenses    = ['MIT']

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.required_ruby_version = '>= 2.5'
  
  spec.add_dependency "ffi", "~> 1.0"
  # Isn't not added as a dependency because
  #  - It's a default gem on MRI 3.4.2 and TruffleRuby 24.2.1
  #  - It's not available as a gem on JRuby
  # spec.add_dependency "etc"
end
