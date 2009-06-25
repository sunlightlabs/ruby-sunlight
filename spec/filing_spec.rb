require File.dirname(__FILE__) + '/spec_helper'

describe Sunlight::Filing do

  before(:each) do

    Sunlight::Base.api_key = 'the_api_key'
    @example_hash = {"client_name" => "SUNLIGHT FOUNDATION", "filing_year" => "2007"}

  end

  describe "#initialize" do

    it "should create an object from a JSON parser-generated hash" do
      sf = Sunlight::Filing.new(@example_hash)
      sf.should be_an_instance_of(Sunlight::Filing)
      sf.client_name.should eql("SUNLIGHT FOUNDATION")
    end

  end

  describe "#all_where" do
    
    it "should return array when valid parameters are passed in" do
      Sunlight::Filing.should_receive(:get_json_data).and_return({"response"=>{"filings"=>[{"filing"=>{"client_name"=>"ABC", "lobbyists" => [{"lobbyist" => {"firstname" => "Bob"}}], "issues" => [{"issue" => {"specific_issue" => "Issue"}}]}}]}})
      
      filings = Sunlight::Filing.all_where(:client_name => "ABC", :year => '2007')
      filings.first.client_name.should eql('ABC')
    
      filings.first.lobbyists.first.should be_an_instance_of(Sunlight::Lobbyist)
      filings.first.lobbyists.first.firstname.should eql("Bob")
      
      filings.first.issues.first.should be_an_instance_of(Sunlight::Issue)
      filings.first.issues.first.specific_issue.should eql("Issue")
    end
        
    it "should return nil on bad data" do
      filings = Sunlight::Filing.all_where(:foo => "bar")
      filings.should be(nil)      
    end    
    
    it "should return nil on failed search" do
      Sunlight::Filing.should_receive(:get_json_data).and_return(nil)
      
      filings = Sunlight::Filing.all_where(:client_name => "bar")
      filings.should be(nil)
    end
    
    it "should return nil on empty search" do
      Sunlight::Filing.should_receive(:get_json_data).and_return({"response" => {"filings" => []}})
      
      filings = Sunlight::Filing.all_where(:client_name => "abc")
      filings.should be(nil)
    end
    
  end
  
  describe "#get" do

    it "should return nil if no match is found" do
      Sunlight::Filing.should_receive(:get_json_data).and_return(nil)
      
      filing = Sunlight::Filing.get("bad ID")
      filing.should be(nil)
    end
    
    it "should return nil on empty reply" do
      Sunlight::Filing.should_receive(:get_json_data).and_return({"response" => {}})
      
      filing = Sunlight::Filing.get("bad ID")
      filing.should be(nil)
    end

    it "should return one record when id is passed in" do
      Sunlight::Filing.should_receive(:get_json_data).and_return({"response" => {"filing"=> {"client_name" => "ABC", "lobbyists" => [{"lobbyist" => {"firstname" => "Bob"}}], "issues" => [{"issue" => {"specific_issue" => "Issue"}}]}}})

      filing = Sunlight::Filing.get("real ID")
      filing.should be_an_instance_of(Sunlight::Filing)
      filing.client_name.should eql('ABC')
      
      filing.lobbyists.first.should be_an_instance_of(Sunlight::Lobbyist)
      filing.lobbyists.first.firstname.should eql("Bob")
      
      filing.issues.first.should be_an_instance_of(Sunlight::Issue)
      filing.issues.first.specific_issue.should eql("Issue")
    end

  end

end