class Omnom < ActiveRecord::Base
  before_validation_on_create :generate_creator_ppl
  after_create                :send_creator_email

  has_many   :noms
  has_many   :pplz
  belongs_to :creator, :class_name => "Ppl"

  validate   :has_at_least_one_nom
  validate   :has_at_least_one_ppl

  accepts_nested_attributes_for :pplz, :noms

  attr_accessor :creator_email

  def activate!
    pplz_to_email_on_activation.each do |ppl|
      Mailer.deliver_vote_invitation(self,ppl.email)
    end
  end

  def verification_code
    creator.verification_code
  end

  def tally
    # Collect the noms and their tallies
    results = {}
    noms.each do |nom|
      results[nom] = pplz.select { |ppl| ppl.voted_for?(nom) }.size
    end

    # Return them in highest to lowest tally
    ordered_results = results.sort { |a,b| b[1] <=> a[1] }

    # Make a more friendly result, an array of usable hashes
    return ordered_results.map { |result| { :nom => result[0], :tally => result[1] } }
  end

  private
    def pplz_to_email_on_activation
      pplz.reject { |ppl| ppl == creator }      
    end

    def send_creator_email
      Mailer.deliver_vote_invitation(self,creator.email)
    end

    def has_at_least_one_nom
      errors.add("noms", "You must have at least one nom") if noms.empty?
    end

    def has_at_least_one_ppl
      errors.add("pplz", "You must have at least one ppl") if pplz.empty?
    end

    def generate_creator_ppl
      if creator_email.blank?
        errors.add("pplz", "You must specify an email for the creator")
        return
      end

      self.creator = pplz.build( :email => self.creator_email )
    end
end
