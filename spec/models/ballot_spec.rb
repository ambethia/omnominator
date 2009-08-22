require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Ballot do
  before(:each) do
    @valid_attributes = {
      :creator_email => "sivle@example.com"
    }
    
    @ballot = Ballot.new(@valid_attributes)
    @ballot.candidates.build( :name => "Jake's Meal Barn")
  end

  it "should create a new instance given valid attributes" do
    @ballot.save!
  end

  it "should have one or more candidates" do
    ballot = Ballot.new(@valid_attributes)

    ballot.should have(1).error_on(:candidates)
  end

  it "should assign the creator as the first voter" do
    ballot = Ballot.create(@valid_attributes)

    ballot.creator.email.should == ballot.creator_email
  end

  it "should have one or more voters" do
    # Make sure we fail to give a valid creator
    ballot = Ballot.new(@valid_attributes.except(:creator_email))

    ballot.should_not be_valid
    ballot.should have(1).error_on(:voters)
  end

  describe "mail notifications" do
    it "should email the ballot creator when created" do
      ballot = Ballot.new(@valid_attributes)
      ballot.candidates.build(:name => "Jake's Meal Barn")
      ballot.candidates.build(:name => "Sally's Salad Shack")
      ballot.candidates.build(:name => "Bob's Burger Bonanza")

      Mailer.should_receive(:deliver_vote_invitation).once.with(ballot, @valid_attributes[:creator_email])

      ballot.save
    end
    
    it "should send emails to each of the voters, except the creator, when activated" do
      ballot = Ballot.new(@valid_attributes)
      ballot.candidates.build(:name => "Jake's Meal Barn")
      ballot.candidates.build(:name => "Sally's Salad Shack")
      ballot.candidates.build(:name => "Bob's Burger Bonanza")

      voter_one   = ballot.voters.build(:email => "one")
      voter_two   = ballot.voters.build(:email => "two")
      voter_three = ballot.voters.build(:email => "three")

      Mailer.should_receive(:deliver_vote_invitation).with(ballot, voter_one.email)
      Mailer.should_receive(:deliver_vote_invitation).with(ballot, voter_two.email)
      Mailer.should_receive(:deliver_vote_invitation).with(ballot, voter_three.email)

      ballot.activate!
    end
  end

  describe "tallies" do
    before(:each) do
      @ballot = Ballot.new(@valid_attributes)
      @candidate_one   = @ballot.candidates.build(:name => "Jake's Meal Barn")
      @candidate_two   = @ballot.candidates.build(:name => "Sally's Salad Shack")
      @candidate_three = @ballot.candidates.build(:name => "Bob's Burger Bonanza")

      @voter_one   = @ballot.voters.build(:email => "one")
      @voter_two   = @ballot.voters.build(:email => "two")
      @voter_three = @ballot.voters.build(:email => "three")

      @voter_one.voted_candidate   = @candidate_one
      @voter_two.voted_candidate   = @candidate_three
      @voter_three.voted_candidate = @candidate_three
    end

    it "should tell us how many people voted for each candiate in highst to lowest order" do
      @ballot.tally.should ==  [ { :candidate => @candidate_three, :tally => 2 }, { :candidate => @candidate_one, :tally => 1}, { :candidate => @candidate_two, :tally => 0 } ]
    end
  end

end
