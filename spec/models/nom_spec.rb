require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Nom do
  before(:each) do
    @valid_attributes = {
      :name => "Jake's Meal Barn"
    }
  end

  it "should create a new instance given valid attributes" do
    Nom.create!(@valid_attributes)
  end

end
