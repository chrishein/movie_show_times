# encoding: UTF-8
require 'nokogiri'
require 'chronic_duration'

module MovieShowTimes
  class Parser
    
    attr_accessor :movies, :theaters
    
    def initialize(language = 'en')
      @language = language
      @language_parser = MovieShowTimes::LanguageParser.new(language)
      @genre_parser = MovieShowTimes::GenreParser.new(language)
      @theaters = Hash.new
      @movies = Hash.new
    end
    
    def parse_show_times(doc)
      theater_elements = doc.xpath(
      "//div[@class='movie_results']/div[@class='theater' and .//h2/a]"
      )
      
      theater_elements.each do |t|
        theater_name = t.search(".//h2[@class='name']/a/text()").text
        theater_info = t.search(".//div[@class='info']/text()").text
        showtimes = []
        @movies = []
        @theaters = []
        movie_elements = t.search(".//div[@class='showtimes']//div[@class='movie']")
        x = 0
        movie_elements.each do |m|
          movie_name = m.search(".//div[@class='name']/a/text()").text.strip
          movie_info_line = m.search(".//span[@class='info']/text()").text
          movie_info = parse_movie_info(movie_info_line)
          
          @movies << { :name => movie_name, :info => movie_info } if @movies[x].nil?
          
          movie_times = m.search(".//div[@class='times']/span/text()")
          times = []
          movie_times.each do |mt|
            time = mt.text.strip
            times << time
            x = x + 1
          end
          
          showtimes << { :name => movie_name, :language => movie_info[:language], :times => times }
        end
        
        @theaters << { :name => theater_name, :info => theater_info, :movies => showtimes }
      end
      
    end
    
    def parse_movie_info(info_line)
      duration = ChronicDuration.parse(info_line)
      genre = @genre_parser.parse(info_line)
      language = @language_parser.parse(info_line)
      
      { :duration => duration, :genre => genre, :language => language }
    end

  end
end