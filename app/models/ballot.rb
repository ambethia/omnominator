class Ballot < ActiveRecord::Base
  before_validation_on_create :generate_creator_voter

  has_many   :candidates
  has_many   :voters
  belongs_to :creator, :class_name => "Voter"

  validate   :has_at_least_one_candidate
  validate   :has_at_least_one_voter

  attr_accessor :creator_email

  def activate!
    # Form of...
  end

  def approve!
    self.approved = true
    save!
  end

  def tally
    results = {}

    candidates.each do |candidate|
      results[candidate] = voters.select { |voter| voter.voted_for?(candidate) }.size
    end

    # Return them in highest to lowest vote totals
    ordered_results = results.sort { |a,b| b[1] <=> a[1] }

    # Make a more friendly result, an array of usable hashes
    return ordered_results.map { |result| { :candidate => result[0], :tally => result[1] } }
  end

  private
    def has_at_least_one_candidate
      errors.add("candidates", "You must have at least one candidate") if candidates.empty?
    end

    def has_at_least_one_voter
      errors.add("voters", "You must have at least one voter") if voters.empty?
    end

    def generate_creator_voter
      if creator_email.blank?
        errors.add("voters", "You must specify an email for the creator")
        return
      end

      self.creator = voters.build( :email => self.creator_email )
    end
end
