# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "fluent-plugin-filter_redfishalert"
  s.version     = "0.0.2"
  s.authors     = ["Tobi Ajagbe"]
  s.email       = ["tobiajagbe@microsoft.com"]
  s.homepage    = "https://github.com/tohbiee/fluent-plugin-filter_redfishalert"
  s.summary     = "A Fluentd filter plugin to rettrieve selected redfish alert"
  s.description = s.summary
  s.licenses    = ["Apache-2.0"]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", "~> 1.14"
  s.add_development_dependency "rake", "~> 12.0"
  s.add_development_dependency "test-unit","~> 3.0"
  s.add_runtime_dependency "fluentd", [">= 0.14.10", "< 2"]
end