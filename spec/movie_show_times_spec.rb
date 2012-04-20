# encoding: UTF-8
require 'spec_helper'
require 'fakeweb'

describe MovieShowTimes do
  context 'parsing a results page' do
    
    before :all do
      @movieShowTimes = MovieShowTimes::Parser.new
      doc = Nokogiri::HTML(File.read('spec/fixtures/movies_bsas.html'))
      @movieShowTimes.parse_show_times(doc)
    end
  
    it "provides a list of all theaters" do
      @movieShowTimes.theaters.length.should == 10
    end
    
    it "provides names of theaters" do
      @movieShowTimes.theaters.should have_key('Monumental')
      @movieShowTimes.theaters.should have_key('Premier')
      @movieShowTimes.theaters.should have_key('Arteplex Centro')
      @movieShowTimes.theaters.should have_key('Cine Hoyts Abasto')
    end
    
    it "provides info of theaters" do
      theater = @movieShowTimes.theaters['Monumental']
      theater[:info].should match('Lavalle 780, Buenos Aires, Argentina - 0-11-4393-9008')
    end
    
    it "provides list of movies for a theater" do
      theater = @movieShowTimes.theaters['Monumental']
      theater[:movies].length.should == 12
      
      theater = @movieShowTimes.theaters['Cine Hoyts Abasto']
      theater[:movies].length.should == 43
    end
    
    it "provides names of movies for a theater" do
      theater = @movieShowTimes.theaters['Monumental']
      theater[:movies].map{ |m| m[:name] }.should 
        include('Wrath of the Titans', 'American Reunion', 'La suerte en tus manos')
    end
    
    it "provides language of movies" do
      
      theater = @movieShowTimes.theaters['Monumental']
      movie = theater[:movies][0]
      movie[:language].should_not be_nil
      movie[:language].should match('English')
      
      theater = @movieShowTimes.theaters['Atlas Patio Bullrich']
      movie = theater[:movies][3]
      movie[:language].should_not be_nil
      movie[:language].should match('Italian')
      
    end
    
    it "provides list of times for movies at a theater" do
      theater = @movieShowTimes.theaters['Monumental']
      movie = theater[:movies][0]
      movie[:times].length.should == 6
    end
    
    it "provides showtimes for movies at a theater" do
      theater = @movieShowTimes.theaters['Monumental']
      movie = theater[:movies][0]
      movie[:times][0].should match('14:00')
    end
    
    it "provides list of movies" do
      @movieShowTimes.movies.should have_key('Mirror Mirror')
      @movieShowTimes.movies.should have_key('Reus')
    end
    
    it "provides movie info with duration" do
      movie = @movieShowTimes.movies['Mirror Mirror']
      movie[:info][:duration].should == (60*60 + 46) #'1hr 46min'
      
      movie = @movieShowTimes.movies['Titanic 3D']
      movie[:info][:duration].should == (3*60*60 + 14) #'3hr 14min'
      
      movie = @movieShowTimes.movies['La sensibilidad']
      movie[:info][:duration].should == 55 #'55min'
      
      movie = @movieShowTimes.movies['Tupac Amaru, algo está cambiando']
      movie[:info][:duration].should be_nil
    end
    
    it "provides movie info with genre" do
      pending
      
      movie = @movieShowTimes.movies['Mirror Mirror']
      movie[:info][:genre].should_not be_nil
      movie[:info][:genre].should match('Scifi/Fantasy')
      
      movie = @movieShowTimes.movies['American Reunion']
      movie[:info][:genre].should_not be_nil
      movie[:info][:genre].should match('Comedy/Romance')
    end

  end
  
  context 'when initialized without location' do
    it "should raise an exception" do
      lambda { MovieShowTimes::Crawler.new() }.should raise_error(MovieShowTimes::Crawler::MissingLocationArgument)
    end
  end
  
  context 'when initialized with location' do
    before :all do
      FakeWeb.allow_net_connect = false
      (1..6).each do |i|
        uri = "http://www.google.com/movies?hl=en&near=Buenos+Aires"
        uri += "&start=#{10*(i - 1)}" if i > 1
        FakeWeb.register_uri(:get, uri,
            :response => File.open("spec/fixtures/movies_bsas_#{i}.txt", 'r').read
        )
      end
      
      @movieShowTimes = MovieShowTimes::Crawler.new({ :location => 'Buenos Aires' })
    end
    
    it "should crawl all result pages" do
      @movieShowTimes.theaters.should_not be_empty
      @movieShowTimes.movies.should_not be_empty      
      @movieShowTimes.theaters.length.should == 37
    end
  end
  
end