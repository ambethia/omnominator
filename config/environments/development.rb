config.cache_classes                                 = false
config.whiny_nils                                    = true
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false
config.action_mailer.raise_delivery_errors           = true
config.action_mailer.default_url_options             = { :host => "0.0.0.0:3000" }

config.gem "ambethia-smtp-tls", :lib => "smtp-tls"
