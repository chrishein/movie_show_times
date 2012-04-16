# encoding: UTF-8
require 'mechanize'
require 'cgi'

module MovieShowTimes
  class Crawler
    
    const_set("MissingLocationArgument", Class.new(StandardError))
    
    def initialize(options={})  
      @parser = MovieShowTimes::Parser.new
      
      raise MissingLocationArgument unless options[:location]
      
      language = options[:language] || 'en'
      search_url = "http://www.google.com/movies?hl=#{language}&near=#{CGI.escape(options[:location])}"      
      
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