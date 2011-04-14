# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cingel_admin/version"

Gem::Specification.new do |s|
  s.name        = "cingel_admin"
  s.version     = CingelAdmin::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Vlado Cingel"]
  s.email       = ["vlado@cingel.hr"]
  s.homepage    = ""
  s.summary     = %q{Cingel Admin}
  s.description = %q{Cingel Admin}

  s.rubyforge_project = "cingel_admin"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
