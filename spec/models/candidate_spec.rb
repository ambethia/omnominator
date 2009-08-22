require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Candidate do
  before(:each) do
    @valid_attributes = {
      :name => "Jake's Meal Barn"
    }
  end

  it "should create a new instance given valid attributes" do
    Candidate.create!(@valid_attributes)
  end

end
