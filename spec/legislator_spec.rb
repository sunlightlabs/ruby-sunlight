require File.dirname(__FILE__) + '/spec_helper'

describe Sunlight::Legislator do

  before :each do

    Sunlight::Base.api_key = 'the_api_key'
    @example_hash = {
      "webform"=>"https://forms.house.gov/wyr/welcome.shtml", 
      "title"=>"Rep", 
      "nickname"=>"", 
      "eventful_id"=>"P0-001-000016482-0", 
      "district"=>"4", 
      "congresspedia_url"=>"http://www.sourcewatch.org/index.php?title=Carolyn_McCarthy", 
      "fec_id"=>"H6NY04112", 
      "middlename"=>"", 
      "gender"=>"F", 
      "congress_office"=>"106 Cannon House Office Building", 
      "lastname"=>"McCarthy", 
      "crp_id"=>"N00001148", 
      "bioguide_id"=>"M000309", 
      "name_suffix"=>"", 
      "phone"=>"202-225-5516", 
      "firstname"=>"Carolyn", 
      "govtrack_id"=>"400257", 
      "fax"=>"202-225-5758", 
      "website"=>"http://carolynmccarthy.house.gov/", 
      "votesmart_id"=>"693", 
      "sunlight_old_id"=>"fakeopenID252", 
      "party"=>"D", 
      "email"=>"", 
      "state"=>"NY"
    }

    @jan = Sunlight::Legislator.new({"firstname" => "Jan", "district" => "Senior Seat", "title" => "Sen"})  
    @bob = Sunlight::Legislator.new({"firstname" => "Bob", "district" => "Junior Seat", "title" => "Sen"})
    @tom = Sunlight::Legislator.new({"firstname" => "Tom", "district" => "4", "title" => "Rep"})

    @example_legislators = {:senior_senator => @jan, :junior_senator => @bob, :representative => @tom}

  end

  describe "#initialize" do

    it "should create an object from a JSON parser-generated hash" do
      carolyn = Sunlight::Legislator.new(@example_hash)
      carolyn.should be_an_instance_of(Sunlight::Legislator)
      carolyn.firstname.should eql("Carolyn")
    end

  end
  
  describe "#youtube_id" do
    
    it "should return blank if youtube_url is nil" do
      @jan.youtube_id.should be nil
    end

    it "should return jansmith if youtube_url is http://www.youtube.com/jansmith" do
      @jan.youtube_url = "http://www.youtube.com/jansmith"
      @jan.youtube_id.should eql("jansmith")
    end

    it "should return jansmith if youtube_url is http://www.youtube.com/user/jansmith" do
      @jan.youtube_url = "http://www.youtube.com/user/jansmith"
      @jan.youtube_id.should eql("jansmith")
    end
    
  end
  
  describe "#committees" do
    
    
    it "should return an array of Committees with subarrays for subcommittees" do
      @example_committee = {"chamber" => "Joint", "id" => "JSPR", "name" => "Joint Committee on Printing", 
                                                                                  "members" => [{"legislator" => {"state" => "GA"}}],
                                                                                  "subcommittees" => [{"committee" => {"chamber" => "Joint", "id" => "JSPR", "name" => "Subcommittee on Ink"}}]}
      
      Sunlight::Base.should_receive(:get_json_data).and_return({"response" => {"committees" => 
                                                                              [{"committee" => @example_committee}]}})
      
      carolyn = Sunlight::Legislator.new(@example_hash)                                                                             
      comms = carolyn.committees
      comms.should be_an_instance_of(Array)
      comms[0].should be_an_instance_of(Sunlight::Committee)
    end
    
    it "should return nil if no committees are found" do
      
      Sunlight::Base.should_receive(:get_json_data).and_return(nil)
      
      carolyn = Sunlight::Legislator.new(@example_hash)                                                                             
      comms = carolyn.committees
      comms.should be_nil
    end
    
  end

  describe "#all_for" do

    it "should return nil when junk is passed in" do
      legislators = Sunlight::Legislator.all_for(:bleh => 'blah')
      legislators.should be(nil)
    end

    it "should return hash when valid lat/long are passed in" do
      Sunlight::Legislator.should_receive(:all_in_district).and_return(@example_legislators)

      legislators = Sunlight::Legislator.all_for(:latitude => 33.876145, :longitude => -84.453789)
      legislators[:senior_senator].firstname.should eql('Jan')
    end

    it "should return hash when valid address is passed in" do
      Sunlight::Legislator.should_receive(:all_in_district).and_return(@example_legislators)

      legislators = Sunlight::Legislator.all_for(:address => "123 Fake St Anytown USA")
      legislators[:junior_senator].firstname.should eql('Bob')
    end

  end

  describe "#all_in_district" do

    it "should return has when valid District object is passed in" do
      Sunlight::Legislator.should_receive(:all_where).exactly(3).times.and_return([@jan])

      legislators = Sunlight::Legislator.all_in_district(Sunlight::District.new("NJ", "7"))
      legislators.should be_an_instance_of(Hash)
      legislators[:senior_senator].firstname.should eql('Jan')
    end

  end


  describe "#all_where" do

    it "should return array when valid parameters passed in" do
      Sunlight::Legislator.should_receive(:get_json_data).and_return({"response"=>{"legislators"=>[{"legislator"=>{"state"=>"GA"}}]}})

      legislators = Sunlight::Legislator.all_where(:firstname => "Susie")
      legislators.first.state.should eql('GA')
    end

    it "should return nil when unknown parameters passed in" do
      Sunlight::Legislator.should_receive(:get_json_data).and_return(nil)

      legislators = Sunlight::Legislator.all_where(:blah => "Blech")
      legislators.should be(nil)
    end

  end
  
  describe "#all_in_zipcode" do
    
    it "should return array when valid parameters passed in" do
      Sunlight::Legislator.should_receive(:get_json_data).and_return({"response"=>{"legislators"=>[{"legislator"=>{"state"=>"GA"}}]}})
      
      legislators = Sunlight::Legislator.all_in_zipcode(:zip => "30339")
      legislators.first.state.should eql('GA')
    end
    
    it "should return nil when unknown parameters passed in" do
      Sunlight::Legislator.should_receive(:get_json_data).and_return(nil)

      legislators = Sunlight::Legislator.all_in_zipcode(:blah => "Blech")
      legislators.should be(nil)
    end
    
  end


  describe "#search_by_name" do
    
    it "should return array when probable match passed in with no threshold" do
      Sunlight::Legislator.should_receive(:get_json_data).and_return({"response"=>{"results"=>[{"result"=>{"score"=>"0.91", "legislator"=>{"firstname"=>"Edward"}}}]}})
      
      legislators = Sunlight::Legislator.search_by_name("Teddy Kennedey")
      legislators.first.fuzzy_score.should eql(0.91)
      legislators.first.firstname.should eql('Edward')
    end
    
    it "should return an array when probable match passed in is over supplied threshold" do
      Sunlight::Legislator.should_receive(:get_json_data).and_return({"response"=>{"results"=>[{"result"=>{"score"=>"0.91", "legislator"=>{"firstname"=>"Edward"}}}]}})
    
      legislators = Sunlight::Legislator.search_by_name("Teddy Kennedey", 0.9)
      legislators.first.fuzzy_score.should eql(0.91)
      legislators.first.firstname.should eql('Edward')
    end
    
    it "should return nil when probable match passed in but underneath supplied threshold" do
      Sunlight::Legislator.should_receive(:get_json_data).and_return({"response"=>{"results"=>[{"result"=>{"score"=>"0.91", "legislator"=>{"firstname"=>"Edward"}}}]}})
    
      legislators = Sunlight::Legislator.search_by_name("Teddy Kennedey", 0.92)
      legislators.should be(nil)
    end
    
    it "should return nil when no probable match at all" do
      Sunlight::Legislator.should_receive(:get_json_data).and_return({"response"=>{"results"=>[]}})
    
      legislators = Sunlight::Legislator.search_by_name("923jkfkj elkji")
      legislators.should be(nil)      
    end
    
    it "should return nil on bad data" do
      Sunlight::Legislator.should_receive(:get_json_data).and_return(nil)
    
      legislators = Sunlight::Legislator.search_by_name("923jkfkj elkji","lkjd")
      legislators.should be(nil)      
    end    
    
    
  end

end
