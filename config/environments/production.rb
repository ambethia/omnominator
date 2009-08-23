config.cache_classes                                 = true
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true
config.action_mailer.default_url_options             = { :host => "omnominator.com" }

config.gem "ambethia-rack-google_analytics", :lib => "rack/google_analytics", :source => "http://gems.github.com"
config.middleware.use "Rack::GoogleAnalytics", :web_property_id => "UA-2098861-8"
