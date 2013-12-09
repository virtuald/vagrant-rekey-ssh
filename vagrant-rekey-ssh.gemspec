# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-rekey-ssh/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-rekey-ssh"
  spec.version       = VagrantPlugins::RekeySSH::VERSION
  spec.authors       = ["Dustin Spicuzza"]
  spec.email         = ["dustin@virtualroadside.com"]
  spec.description   = "Automatically secure vagrant boxes with a randomly generated SSH key"
  spec.summary       = "Automatically secure vagrant boxes with a randomly generated SSH key"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
