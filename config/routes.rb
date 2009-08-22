ActionController::Routing::Routes.draw do |map|
  map.root :controller => "application"

  map.create_omnom '/',                        :controller => "application", :action => "create_omnom", :conditions => { :method => :post }
  map.vote         '/vote/:verification_code', :controller => "application", :aciton => "vote",         :conditions => { :method => :post }
end
