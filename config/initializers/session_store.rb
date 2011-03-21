# Be sure to restart your server when you modify this file.

Txt141::Application.config.session_store :cookie_store, :key => '_txt141_session'

# use redis-store https://github.com/jodosha/redis-store
# Txt141::Application.config.session_store :redis_session_store

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Txt141::Application.config.session_store :active_record_store

      