# encoding: UTF-8
require 'nokogiri'
require 'chronic_duration'

module MovieShowTimes
  class Parser
    
    attr_accessor :movies, :theaters
    
    def initialize()
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
        movie_elements = t.search(".//div[@class='showtimes']//div[@class='movie']")
        
        movie_elements.each do |m|
          movie_name = m.search(".//div[@class='name']/a/text()").text.strip
          movie_info_line = m.search(".//span[@class='info']/text()").text
          movie_info = parse_movie_info(movie_info_line)
          
          @movies[movie_name] = { :name => movie_name, :info => movie_info } if @movies[movie_name].nil?
          
          movie_times = m.search(".//div[@class='times']/span/text()")
          times = []
          movie_times.each do |mt|
            time = mt.text.strip
            times << time
          end
          
          showtimes << { :name => movie_name, :language => movie_info[:language], :times => times }
        end
        
        @theaters[theater_name] = { :name => theater_name, :info => theater_info, :movies => showtimes }
      end
      
    end
    
    def parse_movie_info(info_line)
      duration = ChronicDuration.parse(info_line)
      genre = parse_genre(info_line)
      language = parse_language(info_line)
      
      { :duration => duration, :genre => genre, :language => language }
    end
    
    def parse_language(info_line)
      matches = info_line.match(/(English|Spanish|Hebrew|French|German|Thai)/)
      return matches[0] unless matches.nil?
      nil
    end
    
    def parse_genre(info_line)
      matches = info_line.match(/(Drama|Scifi\/Fantasy|Documentary)/)
      return matches[0] unless matches.nil?
      nil
    end
  end
end