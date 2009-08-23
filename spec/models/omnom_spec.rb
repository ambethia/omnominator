require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Omnom do
  before(:each) do
    @valid_attributes = {
      :creator_email => "sivle@example.com"
    }
    
    @omnom = Omnom.new(@valid_attributes)
    @omnom.noms.build( :name => "Jake's Meal Barn")
  end

  it "should have one or more noms" do
    omnom = Omnom.new(@valid_attributes)

    omnom.should have(1).error_on(:noms)
  end

  it "should assign the creator as the first ppl" do
    omnom = Omnom.create(@valid_attributes)

    omnom.creator.email.should == omnom.creator_email
  end

  it "should use the creator's verification code as our verification code" do
    omnom = Omnom.create(@valid_attributes)

    omnom.creator.verification_code.should == omnom.verification_code
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
      creator = mock_model(Ppl, :email => @valid_attributes[:creator_email])
      
      omnom.stub!(:creator).and_return(creator)
      omnom.noms.build(:name => "Jake's Meal Barn")
      omnom.noms.build(:name => "Sally's Salad Shack")
      omnom.noms.build(:name => "Bob's Burger Bonanza")

      Mailer.should_receive(:deliver_creator_verification).once.with(creator)

      omnom.save
    end
    
    it "should send emails to each of the pplz, except the creator, when activated" do
      omnom = Omnom.new(@valid_attributes)
      omnom.stub!(:send_creator_email)

      omnom.noms.build(:name => "Jake's Meal Barn")
      omnom.noms.build(:name => "Sally's Salad Shack")
      omnom.noms.build(:name => "Bob's Burger Bonanza")
      ppl_one = omnom.pplz.build(:email => "kim@example.com")

      Mailer.should_receive(:deliver_vote_invitation).with(omnom, ppl_one)

      omnom.activate!
    end
    
    it "should not send emails again for an already activated omnom" do
      omnom = Omnom.new(@valid_attributes)
      omnom.stub!(:send_creator_email)

      omnom.noms.build(:name => "Jake's Meal Barn")
      omnom.noms.build(:name => "Sally's Salad Shack")
      omnom.noms.build(:name => "Bob's Burger Bonanza")
      ppl_one = omnom.pplz.build(:email => "kim@example.com")

      Mailer.should_receive(:deliver_vote_invitation).once.with(omnom, ppl_one)

      omnom.activate!
      omnom.activate!
      omnom.activate!
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

    it "should tell us how many people voted for each candiate in highst to lowest order and people in alpha order by email" do
      @omnom.tally.should ==  [ { :nom => @nom_three, :pplz => [ @ppl_three, @ppl_two ] }, { :nom => @nom_one, :pplz => [ @ppl_one ]}, { :nom => @nom_two, :pplz => [] } ]
    end
  end

  describe "activation" do
    before(:each) do
      @omnom = Omnom.new(@valid_attributes)
      @omnom.stub!(:send_creator_email)
      @omnom.stub!(:pplz_to_email_on_activation).and_return([])
    end
  
    it "should not be active by default" do
      @omnom.should_not be_active
    end
  
    it "should be active when activated_at is set" do
      @omnom.activated_at = 5.minutes.ago
      @omnom.should be_active
    end
  
    it "should activate" do
      @omnom.activate!
      @omnom.should be_active
    end
  end

end
