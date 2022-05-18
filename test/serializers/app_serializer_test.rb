require 'test_helper'

class AppsSerializerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
    @team = teams(:three)
    @app = apps(:three)
    @hash = AppSerializer.new(@app).serializable_hash
  end

  test 'should serialize with the correct attributes' do
   assert_equal @hash.dig(:data, :attributes).keys, [:name, :github_repo, :deploy_workflow, :created_at, :updated_at]
  end

  test 'should have the correct relationships' do
    assert_equal @hash.dig(:data, :relationships).keys, [:team, :deployments]
  end

  test 'should have the correct self link' do
    assert_equal @hash.dig(:data, :links, :self), "#{ENV['BASE_URL']}/api/v1/teams/#{@app.team_id}/apps/#{@app.id}"
  end
end
