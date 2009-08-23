ActionController::Routing::Routes.draw do |map|
  map.root :controller => "application"

  map.with_options(:controller => "application") do |map|
    map.create_omnom '/omnom',                   :action => "create_omnom", :conditions => { :method => :post }
    map.vote         '/vote/:verification_code', :action => "vote"
    map.chad         "/chad/:verification_code", :action => "chad",         :conditions => { :method => :post  }
    map.check_your_mail '/check_your_mail',      :action => "check_your_mail"
  end

end
