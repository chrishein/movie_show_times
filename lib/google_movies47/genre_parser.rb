# encoding: UTF-8

module GoogleMovies47
  class GenreParser
    
    def initialize(language = 'en')
      @language = language
      terms = nil
      
      begin
        genres_file_contents = File.open("#{File.dirname(__FILE__)}/genres/#{language}.txt").readlines.map(&:chomp)
        terms = genres_file_contents.join('|')
      rescue Errno::ENOENT
      end
      @regular_expression = Regexp.new("(#{terms})", 'i') unless terms.nil?
    end
    
    def parse(info_line)
      if @regular_expression
        parts = info_line.split(' - ')
        parts.each do |p|
          return p unless @regular_expression.match(p).nil?
        end        
      end
      
      nil
      
    end
  end

end

=begin
i.match("-+[^-]+-")

=end