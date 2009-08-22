class Mailer < ActionMailer::Base
  
  def vote_invitation(ballot, voter_email)
    @recipients         = voter_email
    @subject            = "You've been asked to pick a place to eat on OmNominator"
    @sent_on            = Time.now
    @body[:voter_email] = voter_email
    @body[:url]         = "http://failblog.com" #url_for(:host => host, :action=>"index", :controller=>"home")
  end
end
