# -*- encoding: utf-8 -*-
require File.expand_path('../lib/movie_show_times/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Christian Hein"]
  gem.email         = ["chrishein@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "movie_show_times"
  gem.require_paths = ["lib"]
  gem.version       = MovieShowTimes::VERSION
  
  gem.add_dependency 'mechanize'
  gem.add_dependency 'nokogiri'
  gem.add_dependency 'chronic_duration'
  
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
end
