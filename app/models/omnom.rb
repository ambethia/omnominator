class Omnom < ActiveRecord::Base
  before_validation_on_create :generate_creator_ppl
  after_create                :send_creator_email

  has_many   :noms
  has_many   :pplz
  belongs_to :creator, :class_name => "Ppl"

  validate   :has_at_least_one_nom
  validate   :has_at_least_one_ppl
  validates_presence_of :creator, :message => "Put yur e-mail in the first box!"

  accepts_nested_attributes_for :pplz, :noms

  attr_accessor :creator_email

  def activate!
    return if active?

    update_attribute :activated_at, Time.now

    pplz_to_email_on_activation.each do |ppl|
      Mailer.deliver_vote_invitation(self, ppl)
    end
  end

  def active?
    activated_at
  end

  def verification_code
    creator.verification_code
  end

  # Returns NOMs in decreasing order of the number of pplz, and pplz by email address
  def tally
    results = {}
    noms.each do |nom|
      results[nom] = pplz.select { |ppl| ppl.voted_for?(nom) }.sort_by { |ppl| ppl.email }
    end

    # Return them in highest to lowest tally
    ordered_results = results.sort { |a,b| b[1].size <=> a[1].size }

    # Make a more friendly result, an array of usable hashes
    return ordered_results.map { |result| { :nom => result[0], :pplz => result[1] } }
  end

  private
    def pplz_to_email_on_activation
      pplz.reject { |ppl| ppl == creator }
    end

    def send_creator_email
      Mailer.deliver_creator_verification(creator)
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
