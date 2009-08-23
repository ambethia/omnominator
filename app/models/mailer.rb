class Mailer < ActionMailer::Base
  
  def creator_verification(ppl)
    @recipients         = ppl.email
    @from               = ["Omnominator","no-reply@omnominator.com"]
    @subject            = "Activate your Omnominator!"
    @sent_on            = Time.now
    @body[:ppl]         = ppl
  end
  
  def vote_invitation(omnom, ppl)
    @recipients         = ppl.email
    @from               = ["Omnominator","no-reply@omnominator.com"]
    @reply_to           = omnom.creator.email
    @subject            = "You've been asked to pick a place to eat on OmNominator"
    @sent_on            = Time.now
    @body[:ppl]         = ppl
    @body[:creator]     = omnom.creator.name ? omnom.creator.email : omnom.creator.name
  end
end
