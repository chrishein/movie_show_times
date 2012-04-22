# MovieShowTimes

Get Movies Show Times for all theaters near a given location.

The gem crawls and parses Google Movies pages.

## Installation

Add this line to your application's Gemfile:

    gem 'movie_show_times'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install movie_show_times

## Usage

A location is required to initialize the crawling. By default, it gets show times for the current date.

    movieShowTimes = MovieShowTimes::Crawler.new({ :location => 'Buenos Aires' })

    theater = movieShowTimes.theaters['Monumental']
    puts theater # => { :name => 'Monumental', :info => 'Lavalle 780, Buenos Aires, Argentina - 0-11-4393-9008',
                        :movies => [ ... ]
                      }

    puts theater[:movies][0] # => { :name => 'Titanic 3D', 
                                       :info => { 	:duration => 10814, 
													:language => 'English', 
													:genre => 'Action/Adventure/Drama'
												}
                                       :times => ['13:30', '17:30', '21:30', '01:00']
                                     }


You can retrieve movie show times for following days. There is no definition for how far in the future will this information be available, so use with caution as it may be the cause for retrieving no show times at all.

    movieShowTimes = MovieShowTimes::Crawler.new({ 	:location => 'Buenos Aires',
													:days_ahead => 2
 												})

## TODO

Improve API

Include more movie info from other data sources

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Copyright © 2012 Christian Hein, released under the MIT license
