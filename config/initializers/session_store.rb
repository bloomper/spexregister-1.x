# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_spexregister_session',
  :secret      => 'f73e9a587ef587e4c78c1f26d49bb7f1dab5d6075fc03b8543acb385798c840c7313380c5643999c13208d0892c79a5ade0b0af04dbd99bfe7cbd4fa9143cd28'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
