ActionController::Routing::Routes.draw do |map|
  map.root :controller => "application"

  map.with_options(:controller => "application") do |map|
    map.create_omnom '/omnom',                   :action => "create_omnom", :conditions => { :method => :post }
    map.vote         '/vote/:verification_code', :action => "vote"
  end

end
