# encoding: UTF-8
require 'spec_helper'

describe GoogleMovies47::GenreParser do
  context 'when initialized with language that does not have genre names file' do
    it "it should return nil" do
      @parser = GoogleMovies47::GenreParser.new('ur')
      @parser.parse('1گھنٹ�? 40م�?�? - �?سپانوی').should be_nil
    end
  end
  
  
  context 'parsing an info string' do
    context 'in english' do
      before :all do
        @parser = GoogleMovies47::GenreParser.new('en')
      end

      it "detects genre name" do
        @parser.parse('1hr 25min‎- Suspense - English').should match('Suspense')
      end

      it "detects genres names when there is more than one" do
        @parser.parse('1hr 25min‎- Suspense/Thriller - English').should match('Suspense/Thriller')
      end
    end
    
    context 'in spanish' do
      before :all do
        @parser = GoogleMovies47::GenreParser.new('es')
      end

      it "detects genres names" do
        @parser.parse('1h 57min‎- Acción/Aventuras/Drama‎- inglés‎').should match('Acción/Aventuras/Drama')
      end
    end
  end
end