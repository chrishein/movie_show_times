# encoding: UTF-8
require 'mechanize'
require 'cgi'

module MovieShowTimes
  class Crawler
    
    const_set("MissingLocationArgument", Class.new(StandardError))
    const_set("WrongDaysAheadArgument", Class.new(StandardError))
    
    def initialize(options = {})
      
      raise MissingLocationArgument unless options[:city] and options[:state]
      
      language = options[:language] || 'en'
      
      days_ahead = options[:days_ahead] || 0
      raise WrongDaysAheadArgument unless days_ahead.kind_of? Integer and 0 >= days_ahead
      
      @parser = MovieShowTimes::Parser.new(language)
      
      search_url = "http://www.google.com/movies?hl=#{language}" \
                    "&near=#{CGI.escape(options[:city])}+#{CGI.escape(options[:state])}&date=#{days_ahead}"
      
      @agent = Mechanize.new
      page = @agent.get(search_url)
      
      crawl_result_pages(page)
      
    end
    
    def movies
      @parser.movies
    end
    
    def theaters
      @parser.theaters
    end
    
    private
    
    def crawl_result_pages(page)
      result_pages = []
      
      doc = page.parser
      result_pages << doc
      
      doc.xpath("//div[@id='navbar']/table//tr/td[not(@class='b')]/a").each do |p|
        result_pages << @agent.get(p['href']).parser
      end
     
      result_pages.each do |rp|
        @parser.parse_show_times(rp)
      end
    end
  end
end