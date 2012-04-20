# encoding: UTF-8

module MovieShowTimes
  class LanguageParser
    
    def initialize(language = 'en')
      @language = language
      language_names = nil
      
      begin
        lang_file_contents = File.open("#{File.dirname(__FILE__)}/languages/#{language}.txt").readlines.map(&:chomp)
        language_names = lang_file_contents.join('|')
      rescue Errno::ENOENT
      end
      @language_regular_expression = Regexp.new("(#{language_names})", 'i') unless language_names.nil?
    end
    
    def parse(info_line)
      if @language_regular_expression
        matches = @language_regular_expression.match(info_line)
        return matches[0].capitalize unless matches.nil?
      end
      nil
    end
  end
end