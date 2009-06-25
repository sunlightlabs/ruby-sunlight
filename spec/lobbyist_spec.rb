require File.dirname(__FILE__) + '/spec_helper'

describe Sunlight::Lobbyist do

  before(:each) do

    Sunlight::Base.api_key = 'the_api_key'
    @example_hash = {"firstname" => "Bob", "middlename" => "J.", "lastname" => "Smith", "suffix" => "Jr."} 

  end

  describe "#initialize" do

    it "should create an object from a JSON parser-generated hash" do
      bob = Sunlight::Lobbyist.new(@example_hash)
      bob.should be_an_instance_of(Sunlight::Lobbyist)
      bob.firstname.should eql("Bob")
    end

  end

  describe "#search_by_name" do
    
    it "should return array when probable match passed in with no threshold" do
      Sunlight::Lobbyist.should_receive(:get_json_data).and_return({"response"=>{"results"=>[{"result"=>{"score"=>"0.91", "lobbyist"=>{"firstname"=>"Edward"}}}]}})
      
      lobbyists = Sunlight::Lobbyist.search_by_name("Teddy Kennedey")
      lobbyists.first.fuzzy_score.should eql(0.91)
      lobbyists.first.firstname.should eql('Edward')
    end
    
    it "should return an array when probable match passed in is over supplied threshold" do
      Sunlight::Lobbyist.should_receive(:get_json_data).and_return({"response"=>{"results"=>[{"result"=>{"score"=>"0.91", "lobbyist"=>{"firstname"=>"Edward"}}}]}})

      lobbyists = Sunlight::Lobbyist.search_by_name("Teddy Kennedey", 0.9)
      lobbyists.first.fuzzy_score.should eql(0.91)
      lobbyists.first.firstname.should eql('Edward')
    end
    
    it "should return nil when probable match passed in but underneath supplied threshold" do
      Sunlight::Lobbyist.should_receive(:get_json_data).and_return({"response"=>{"results"=>[{"result"=>{"score"=>"0.91", "lobbyist"=>{"firstname"=>"Edward"}}}]}})
    
      lobbyists = Sunlight::Lobbyist.search_by_name("Teddy Kennedey", 0.92, 2005)
      lobbyists.should be(nil)
    end
    
    it "should return nil when no probable match at all" do
      Sunlight::Lobbyist.should_receive(:get_json_data).and_return({"response"=>{"results"=>[]}})
    
      lobbyists = Sunlight::Lobbyist.search_by_name("923jkfkj elkji")
      lobbyists.should be(nil)      
    end
    
    it "should return nil on bad data" do
      Sunlight::Lobbyist.should_receive(:get_json_data).and_return(nil)
    
      lobbyists = Sunlight::Lobbyist.search_by_name("923jkfkj elkji","lkjd")
      lobbyists.should be(nil)      
    end    
    
  end

end