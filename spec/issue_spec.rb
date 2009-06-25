require File.dirname(__FILE__) + '/spec_helper'

describe Sunlight::Issue do

  before(:each) do
    @example_hash = {"code" => "123", "specific_issue" => "Important Stuff"}
  end

  describe "#initialize" do

    it "should create an object from a JSON parser-generated hash" do
      issue = Sunlight::Issue.new(@example_hash)
      issue.should be_an_instance_of(Sunlight::Issue)
      issue.specific_issue.should eql("Important Stuff")
    end

  end
  
end