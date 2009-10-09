class Ppl < ActiveRecord::Base
  before_validation_on_create :generate_verification_code
  belongs_to                  :omnom
  belongs_to                  :voted_nom, :class_name => "Nom"

  validates_format_of :email,
     :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
     :message => "Someone's email address is invalid!"

  # We are the same ppl if we have the same email
  def ===(other)
    other.email == self.email
  end

  def verify!
    if omnom.creator === self
      omnom.activate!
    end
  end

  def voted_for?(nom)
    voted_nom == nom
  end

  private
    def generate_verification_code
      # Our verification codes are just like GUIDs, but different.  No darn dashes
      self.verification_code = Guid.new.to_s.gsub(/-/,"")
    end

end
