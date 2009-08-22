ActionController::Routing::Routes.draw do |map|
  map.root :controller => "application"

  map.create_omnom '/', :controller => "application", :action => "create_omnom"
end
