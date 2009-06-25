require File.dirname(__FILE__) + '/spec_helper'

describe Sunlight::Base do

  before(:each) do
    Sunlight::Base.api_key = 'the_api_key'
    @sunlight = Sunlight::Base.new
  end

  describe "#hash2get" do

    it "should convert a hash to a GET string" do
      get_string = Sunlight::Base.hash2get(:firstname => "Barack", :lastname => "Obama")
      get_string.should satisfy { |s| s == '&firstname=Barack&lastname=Obama' or s == '&lastname=Obama&firstname=Barack' }
    end

  end

  describe "#construct_url" do

    it "should construct a properly formatting API URL" do
      Sunlight::Base.stub!(:hash2get).and_return("&firstname=Nancy&lastname=Pelosi")

      url = Sunlight::Base.construct_url("test.method", {})
      url.should eql('http://services.sunlightlabs.com/api/test.method.json?apikey=the_api_key&firstname=Nancy&lastname=Pelosi')
    end
    
    it "should raise an exception when key is nil" do
      Sunlight::Base.stub!(:hash2get).and_return(nil)
      Sunlight::Base.api_key = nil
      
      lambda {Sunlight::Base.construct_url("test.method", {})}.should raise_error
    end
    
    it "should raise an exception when key is blank" do
      Sunlight::Base.stub!(:hash2get).and_return(nil)
      Sunlight::Base.api_key = ''
      
      lambda {Sunlight::Base.construct_url("test.method", {})}.should raise_error
    end
    
    

  end

  describe "#get_json_data" do

    it "should return JSON data from a URL" do
      mock_response = mock Net::HTTPOK
      mock_response.should_receive(:class).and_return(Net::HTTPOK)
      mock_response.should_receive(:body).and_return("{\"response\": {\"districts\": [{\"district\": {\"state\": \"GA\", \"number\": \"6\"}}]}}")
      Net::HTTP.should_receive(:get_response).and_return(mock_response)

      data = Sunlight::Base.get_json_data("http://someurl.com")
      data.should == {"response"=>{"districts"=>[{"district"=>{"number"=>"6","state"=>"GA"}}]}}
    end

    it "should return nil when JSON URL returns error code" do
      mock_response = mock Net::HTTPNotFound
      Net::HTTP.should_receive(:get_response).and_return(mock_response)

      data = Sunlight::Base.get_json_data("http://someurl.com")
      data.should be(nil)
    end

  end

end
