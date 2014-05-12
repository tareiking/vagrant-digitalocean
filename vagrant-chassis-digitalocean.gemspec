# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-chassis-digitalocean/version'

Gem::Specification.new do |gem|
  gem.name          = "vagrant-chassis-digitalocean"
  gem.version       = VagrantPlugins::DigitalOcean::VERSION
  gem.authors       = ["Bronson Quick"]
  gem.email         = ["bronson@sennza.com.au"]
  gem.description   = %q{Enables Vagrant to manage instances of Chassis on Digital Ocean droplets}
  gem.summary       = gem.description

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "faraday", ">= 0.8.6"
  gem.add_dependency "json"
  gem.add_dependency "log4r"
end
