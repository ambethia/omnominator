# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_omnominator_session',
  :secret      => '2f1fc33d61b07eb89204078f5b52daa2ee653b3929fe1b9613b5f0eeb07d8e7a3b86b0893e899b1157003d82b02d863cb11ce178681ab48a4e825cdb963e6e78'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
