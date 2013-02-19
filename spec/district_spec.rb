require File.dirname(__FILE__) + '/spec_helper'

describe Sunlight::Deprecated::District do

  before(:each) do
    Sunlight::Base.api_key = 'the_api_key'
    Sunlight::Deprecated::District.stub!(:construct_url).and_return("http://someurl.com")
  end

  describe "#get" do

    it "should return nil if junk is passed in" do
      district = Sunlight::Deprecated::District.get(:bleh => 'blah')
      district.should be(nil)
    end

    it "should return one record when lat/long are passed in" do
      Sunlight::Deprecated::District.should_receive(:get_from_lat_long).and_return(Sunlight::Deprecated::District.new('NJ', '05'))

      district = Sunlight::Deprecated::District.get(:latitude => 123.45, :longitude => -123.45)
      district.state.should eql('NJ')
      district.number.should eql('5')
    end

  end

  describe "#get_from_lat_long" do

    it "should return one record when valid lat/long are passed in" do
      Sunlight::Deprecated::District.should_receive(:get_json_data).and_return({"response"=>{"districts"=>[{"district"=>{"number"=>"06","state"=>"GA"}}]}})

      district = Sunlight::Deprecated::District.get_from_lat_long(123.45, -123.45)
      district.state.should eql('GA')
      district.number.should eql('6')
    end

    it "should return nil when invalid lat/long are passed in" do
      Sunlight::Deprecated::District.should_receive(:get_json_data).and_return(nil)

      district = Sunlight::Deprecated::District.get_from_lat_long(123.45, -123.45)
      district.should be(nil)
    end

  end

  describe "#all_from_zipcode" do

    it "should return array when valid zipcode is passed in" do
      Sunlight::Deprecated::District.should_receive(:get_json_data).and_return({"response"=>{"districts"=>[{"district"=>{"number"=>"06","state"=>"GA"}}]}})

      districts = Sunlight::Deprecated::District.all_from_zipcode('12345')
      districts.first.state.should eql('GA')
      districts.first.number.should eql('6')
    end


    it "should return nil when invalid zipcode is passed in" do
      Sunlight::Deprecated::District.should_receive(:get_json_data).and_return(nil)

      districts = Sunlight::Deprecated::District.all_from_zipcode('12345')
      districts.should be(nil)
    end

  end

  describe "#zipcodes_in" do

    it "should return array when valid state/district is passed in" do
      Sunlight::Deprecated::District.should_receive(:get_json_data).and_return({"response"=>{"zips"=>["12345", "23456"]}})

      zipcodes = Sunlight::Deprecated::District.zipcodes_in('NJ', '5')
      zipcodes.first.should eql("12345")
    end


    it "should return nil when invalid state/district is passed in" do
      Sunlight::Deprecated::District.should_receive(:get_json_data).and_return(nil)

      zipcodes = Sunlight::Deprecated::District.zipcodes_in('NJ', '5')
      zipcodes.should be(nil)
    end

  end

end
