require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Ppl do
  before(:each) do
    @valid_attributes = {
      :email => "bill.clinton@example.com"
    }
  end

  it "should create a new instance given valid attributes" do
    Ppl.create!(@valid_attributes)
  end

  it "should require an email for pplz" do
    ppl = Ppl.create(@valid_attributes.except(:email))
    
    ppl.should have(1).error_on(:email)
  end

  it "should have a GUIDish (yes, thats an official term) verification code" do
    ppl = Ppl.create(@valid_attributes)

    ppl.save
    ppl.verification_code.should match(/[0-9a-f]{32}/)
  end

  describe "knows who we voted for" do
    it "should recognize someone we did vote for" do
      nom_voted_for = Nom.create(:name => "Jake's Meal Barn")

      ppl = Ppl.create(@valid_attributes.merge(:voted_nom => nom_voted_for))

      ppl.voted_for?(nom_voted_for).should be_true
    end

    it "should recognize someone we did NOT vote for" do
      nom_voted_for     = Nom.create(:name => "Jake's Meal Barn")
      nom_not_voted_for = Nom.create(:name => "Bill's Burger Bonanza")

      ppl = Ppl.create(@valid_attributes.merge(:voted_nom => nom_voted_for))

      ppl.voted_for?(nom_not_voted_for).should be_false
    end
  end


  describe "verification" do
    it "when the omnom owner performs a verification, that should activate the omnom" do
      omnom = Omnom.create!(:creator_email => "bill.clinton@example.com", :noms => [ Nom.new({ :name => "Jake's Meal Barn" }) ] )

      # Because of the way Rails builds associations, the object chain forward and reverse are not necessarily the same objects in memory
      # Yeah, this looks weird, but its OK.
      omnom.pplz.each { |ppl| ppl.omnom = omnom }

      omnom.should_receive(:activate!).once

      omnom.creator.verify!
    end

    it "when a non omnom owner performs a verification, that should not touch the omnom" do
      omnom = Omnom.create!(:creator_email => "bill.clinton@example.com", :noms => [ Nom.new({ :name => "Jake's Meal Barn" }) ] )

      non_creator = omnom.pplz.build(:email => "hillary.clinton@example.com")

      # Because of the way Rails builds associations, the object chain forward and reverse are not necessarily the same objects in memory
      # Yeah, this looks weird, but its OK.
      omnom.pplz.each { |ppl| ppl.omnom = omnom }

      omnom.should_not_receive(:activate!)

      non_creator.verify!
    end
  end

end
