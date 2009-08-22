require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Omnom do
  before(:each) do
    @valid_attributes = {
      :creator_email => "sivle@example.com"
    }
    
    @omnom = Omnom.new(@valid_attributes)
    @omnom.noms.build( :name => "Jake's Meal Barn")
  end

  it "should create a new instance given valid attributes" do
    @omnom.save!
  end

  it "should have one or more noms" do
    omnom = Omnom.new(@valid_attributes)

    omnom.should have(1).error_on(:noms)
  end

  it "should assign the creator as the first ppl" do
    omnom = Omnom.create(@valid_attributes)

    omnom.creator.email.should == omnom.creator_email
  end

  it "should have one or more pplz" do
    # Make sure we fail to give a valid creator
    omnom = Omnom.new(@valid_attributes.except(:creator_email))

    omnom.should_not be_valid
    omnom.should have(1).error_on(:pplz)
  end

  describe "mail notifications" do
    it "should email the omnom creator when created" do
      omnom = Omnom.new(@valid_attributes)
      omnom.noms.build(:name => "Jake's Meal Barn")
      omnom.noms.build(:name => "Sally's Salad Shack")
      omnom.noms.build(:name => "Bob's Burger Bonanza")

      Mailer.should_receive(:deliver_vote_invitation).once.with(omnom, @valid_attributes[:creator_email])

      omnom.save
    end
    
    it "should send emails to each of the pplz, except the creator, when activated" do
      omnom = Omnom.new(@valid_attributes)
      omnom.noms.build(:name => "Jake's Meal Barn")
      omnom.noms.build(:name => "Sally's Salad Shack")
      omnom.noms.build(:name => "Bob's Burger Bonanza")

      ppl_one   = omnom.pplz.build(:email => "one")
      ppl_two   = omnom.pplz.build(:email => "two")
      ppl_three = omnom.pplz.build(:email => "three")

      Mailer.should_receive(:deliver_vote_invitation).with(omnom, ppl_one.email)
      Mailer.should_receive(:deliver_vote_invitation).with(omnom, ppl_two.email)
      Mailer.should_receive(:deliver_vote_invitation).with(omnom, ppl_three.email)

      omnom.activate!
    end
  end

  describe "tallies" do
    before(:each) do
      @omnom = Omnom.new(@valid_attributes)
      @nom_one   = @omnom.noms.build(:name => "Jake's Meal Barn")
      @nom_two   = @omnom.noms.build(:name => "Sally's Salad Shack")
      @nom_three = @omnom.noms.build(:name => "Bob's Burger Bonanza")

      @ppl_one   = @omnom.pplz.build(:email => "one")
      @ppl_two   = @omnom.pplz.build(:email => "two")
      @ppl_three = @omnom.pplz.build(:email => "three")

      @ppl_one.voted_nom   = @nom_one
      @ppl_two.voted_nom   = @nom_three
      @ppl_three.voted_nom = @nom_three
    end

    it "should tell us how many people voted for each candiate in highst to lowest order" do
      @omnom.tally.should ==  [ { :nom => @nom_three, :tally => 2 }, { :nom => @nom_one, :tally => 1}, { :nom => @nom_two, :tally => 0 } ]
    end
  end

end
