require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Voter do
  before(:each) do
    @valid_attributes = {
      :email => "bill.clinton@example.com"
    }
  end

  it "should create a new instance given valid attributes" do
    Voter.create!(@valid_attributes)
  end

  it "should require an email for a voter" do
    voter = Voter.create(@valid_attributes.except(:email))
    
    voter.should have(1).error_on(:email)
  end

  it "should have a GUIDish (yes, thats an official term) verification code" do
    voter = Voter.create(@valid_attributes)

    voter.save
    voter.verification_code.should match(/[0-9a-f]{32}/)
  end

  describe "knows who we voted for" do
    it "should recognize someone we did vote for" do
      candidate_voted_for = Candidate.create(:name => "Jake's Meal Barn")

      voter = Voter.create(@valid_attributes.merge(:voted_candidate => candidate_voted_for))

      voter.voted_for?(candidate_voted_for).should be_true
    end

    it "should recognize someone we did NOT vote for" do
      candidate_voted_for     = Candidate.create(:name => "Jake's Meal Barn")
      candidate_not_voted_for = Candidate.create(:name => "Bill's Burger Bonanza")

      voter = Voter.create(@valid_attributes.merge(:voted_candidate => candidate_voted_for))

      voter.voted_for?(candidate_not_voted_for).should be_false
    end
  end


  describe "verification" do
    it "when a voter who is the ballot owner performs a verification, that should verify the ballot" do
      ballot = Ballot.create!(:creator_email => "bill.clinton@example.com", :candidates => [ Candidate.new({ :name => "Jake's Meal Barn" }) ] )

      # Because of the way Rails builds associations, the object chain forward and reverse are not necessarily the same objects in memory
      # Yeah, this looks weird, but its OK.
      ballot.voters.each { |voter| voter.ballot = ballot }

      ballot.should_receive(:activate!).once

      ballot.creator.verify!
    end

    it "when a voter who is NOT the ballot owner performs a verification, that should not touch the ballot" do
      ballot = Ballot.create!(:creator_email => "bill.clinton@example.com", :candidates => [ Candidate.new({ :name => "Jake's Meal Barn" }) ] )

      non_creator = ballot.voters.build(:email => "hillary.clinton@example.com")

      # Because of the way Rails builds associations, the object chain forward and reverse are not necessarily the same objects in memory
      # Yeah, this looks weird, but its OK.
      ballot.voters.each { |voter| voter.ballot = ballot }

      ballot.should_not_receive(:activate!)

      non_creator.verify!
    end
  end

end
