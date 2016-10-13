# coding: utf-8
# keyring:  System keyring abstraction library
# License: MIT (http://www.opensource.org/licenses/mit-license.php)

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'keyring/version'

Gem::Specification.new do |spec|
  spec.name          = "keyring"
  spec.version       = Keyring::VERSION
  spec.authors       = ["Jason Heiss"]
  spec.email         = ["jheiss@aput.net"]
  spec.description   = %q{This library provides a easy way to access the system keyring service from ruby}
  spec.summary       = %q{Store and access your passwords safely}
  spec.homepage      = "https://github.com/jheiss/keyring"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'mocha'
  spec.add_dependency 'slop', "< 4.0"

  # Note that when updating these versions you must also make
  # equivalent changes in ext/mkrf_conf.rb

  case Gem::Platform.local.os
    when 'linux'
      spec.add_dependency "gir_ffi-gnome_keyring", '~> 0.0.3'
    when 'darwin'
      spec.add_dependency 'ruby-keychain', '~> 0.3.2'
  end

  spec.extensions = %w[ext/mkrf_conf.rb]

end
