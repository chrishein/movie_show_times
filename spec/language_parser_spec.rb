# encoding: UTF-8
require 'spec_helper'

describe GoogleMovies47::LanguageParser do
  context 'when initialized with language that does not have language names file' do
    it "it should return nil" do
      @language_parser = GoogleMovies47::LanguageParser.new('ur')
      @language_parser.parse('1گھنٹ�? 40م�?�? - �?سپانوی').should be_nil
    end
  end
  
  
  context 'parsing an info string' do
    context 'in english' do
      before :all do
        @language_parser = GoogleMovies47::LanguageParser.new('en')
      end

      it "detects languages names" do
        @language_parser.parse('1hr 25min‎- Suspense/Thriller - English').should match('English')
      end
    end
    
    context 'in spanish' do
      before :all do
        @language_parser = GoogleMovies47::LanguageParser.new('es')
      end

      it "detects languages names" do
        @language_parser.parse('1h 57min‎- Acción/Aventuras/Drama‎- inglés‎').should match('Inglés')
      end
    end
  end
end