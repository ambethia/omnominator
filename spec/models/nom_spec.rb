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

  it "should strip out not allowed HTML tags from the details" do
    nom = Nom.new(@valid_attributes.merge(:details => "<script>alert()</alert><p>paragraph</p><a href='http://google.com'>link</a><br/>"))

    nom.save

    nom.details.should_not match(/script/)
    nom.details.should match(/href=/)
  end
end
