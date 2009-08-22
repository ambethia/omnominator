class Mailer < ActionMailer::Base
  
  def vote_invitation(ballot, voter, host)
    @recipients = voter.email
    @subject = "You've been asked to pick a place to eat on OmNominator"
    @sent_on = Time.now
    @body[:host] = host
    @body[:voter] = voter
    @body[:url] = "http://failblog.com" #url_for(:host => host, :action=>"index", :controller=>"home")
  end
end
