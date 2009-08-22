class Voter < ActiveRecord::Base
  before_validation_on_create :generate_verification_code
  belongs_to                  :ballot
  belongs_to                  :voted_candidate, :class_name => "Candidate"

  validates_presence_of :email

  # We are the same voter if we have the same email
  def ===(other)
    other.email == self.email
  end

  def verify!
    if ballot.creator === self
      ballot.activate!
    end
  end

  def voted_for?(candidate)
    voted_candidate == candidate
  end

  private
    def generate_verification_code
      # Our verification codes are just like GUIDs, but different.  No darn dashes
      self.verification_code = Guid.new.to_s.gsub(/-/,"")
    end

end
