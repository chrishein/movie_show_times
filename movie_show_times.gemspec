# -*- encoding: utf-8 -*-
require File.expand_path('../lib/movie_show_times/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Christian Hein","Jacob Williams"]
  gem.email         = ["chrishein@gmail.com","ponyboy47@gmail.com"]
  gem.description   = %q{Get Movie Show Times by Location}
  gem.summary       = %q{Google Movies crawler and parser}
  gem.homepage      = "https://github.com/Ponyboy47/movie_show_times"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "google_movies47"
  gem.require_paths = ["lib"]
  gem.version       = MovieShowTimes::VERSION
  
  gem.add_dependency 'mechanize'
  gem.add_dependency 'nokogiri'
  gem.add_dependency 'chronic_duration'
  
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'fakeweb'
end
