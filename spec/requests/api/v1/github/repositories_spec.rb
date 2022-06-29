# frozen_string_literal: true

# require 'swagger_helper'

# RSpec.describe 'api/v1/github/repositories', type: :request do
#   fixtures :users, :teams, :apps

#   before(:each) do
#     @user = users(:john)
#     setup_omniauth_mock(@user)
#     VCR.insert_cassette('rswag/repositories')
#   end

#   after(:each) do
#     VCR.eject_cassette
#   end

#   path '/v1/teams/{team_id}/apps/{app_id}/repositories/{id}' do
#     parameter name: 'team_id', in: :path, type: :int, description: 'team_id'
#     parameter name: 'app_id', in: :path, type: :int, description: 'app_id'
#     parameter name: 'id', in: :path, type: :string, description: 'repository_id'

#     let(:team_id) { teams(:three).id }
#     let(:app_id) { apps(:four).id }
#     let(:owner) { 'department-of-veterans-affairs' }
#     let(:id) { 'platform-console-api' }

#     get 'shows repository' do
#       response(200, 'OK') do
#         include_context 'run request test'
#       end
#     end
#   end
# end
