class Mailer < ActionMailer::Base
  
  def vote_invitation(omnom, ppl_email)
    @recipients         = ppl_email
    @subject            = "You've been asked to pick a place to eat on OmNominator"
    @sent_on            = Time.now
    @body[:ppl_email]   = ppl_email
    @body[:url]         = "http://failblog.com" #url_for(:host => host, :action=>"index", :controller=>"home")
  end
end
