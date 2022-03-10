# frozen_string_literal: true

if ENV['COVERAGE'] || ENV['CI']
  require 'simplecov'

  SimpleCov.start 'rails' do
    add_filter 'lib/templates'
    add_filter 'lib/dotenv'
    coverage_dir 'public/coverage'
  end
end

ENV['RAILS_ENV'] ||= 'test'
ENV['KEYCLOAK_SITE_URL'] = 'http://www.example.com/auth/keycloak/callback'
require_relative '../config/environment'
require 'rails/test_help'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'test/vcr_cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('github_token') { ENV['GITHUB_ACCESS_TOKEN'] }
  config.filter_sensitive_data('github_client_id') { ENV['GITHUB_CLIENT_ID'] }
  config.filter_sensitive_data('github_client_secret') { ENV['GITHUB_CLIENT_SECRET'] }
  # whitelist 127.0.0.1 so VCR doesn't interfere with system tests
  config.ignore_hosts '127.0.0.1'
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers

    # Don't parallelize because there is an issue with simplecov
    # See: https://github.com/simplecov-ruby/simplecov/issues/718
    # parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    def setup_omniauth_mock(user)
      OmniAuth.config.test_mode = true
      request = ActionDispatch::Request.new({})
      request.env['omniauth.auth'] = keycloak_auth(user)
      get '/auth/keycloak/callback'
    end

    def keycloak_auth(user)
      OmniAuth.config.mock_auth[:keycloak] =
        OmniAuth::AuthHash.new(
          {
            uid: user.uid,
            provider: 'keycloak',
            info: {
              email: user.email,
              name: user.name
            }
          }
        )
    end

    def login_as(user)
      visit "/login?request.omniauth[uid]=#{users(user).uid}"
    end
  end
end
