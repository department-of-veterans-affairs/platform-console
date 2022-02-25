# frozen_string_literal: true

require 'test_helper'

module Github
  class WorkflowRunsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:john)
      setup_omniauth_mock(@user)
      @team = teams(:three)
      @app = apps(:three)
    end

    test 'should get index' do
      VCR.use_cassette('github/workflow_runs_controller') do
        get team_app_github_repository_workflow_workflow_runs_path(@team, @app, @app.github_repo, 7_426_309)
        assert_response :success
      end
    end

    test 'should get index in json format' do
      VCR.use_cassette('github/workflow_runs_controller') do
        get "#{team_app_github_repository_workflow_workflow_runs_path(@team, @app, @app.github_repo, 7_426_309)}.json"
        assert_response :success
        json_response = JSON.parse(response.body)
        expected_keys = %w[id name node_id head_branch head_sha run_number event status conclusion workflow_id
                           check_suite_id check_suite_node_id url html_url pull_requests created_at updated_at
                           run_attempt run_started_at jobs_url logs_url check_suite_url artifacts_url cancel_url
                           rerun_url previous_attempt_url workflow_url head_commit repository head_repository]
        assert(expected_keys.all? { |k| json_response['workflow_runs'].first.key? k })
      end
    end

    test 'should show workflow run' do
      VCR.use_cassette('github/workflow_runs_controller', record: :new_episodes) do
        get team_app_github_repository_workflow_workflow_run_path(@team, @app, @app.github_repo, 7_426_309,
                                                                  1_859_445_208)
        assert_response :success
      end
    end

    test 'should show workflow run in json format' do
      VCR.use_cassette('github/workflow_runs_controller') do
        get "#{team_app_github_repository_workflow_workflow_run_path(@team, @app, @app.github_repo, 7_426_309,
                                                                     1_859_445_208)}.json"
        assert_response :success
        json_response = JSON.parse(response.body)
        expected_keys = %w[id name node_id head_branch head_sha run_number event status conclusion workflow_id
                           check_suite_id check_suite_node_id url html_url pull_requests created_at updated_at
                           run_attempt run_started_at jobs_url logs_url check_suite_url artifacts_url cancel_url
                           rerun_url previous_attempt_url workflow_url head_commit repository head_repository]
        assert(expected_keys.all? { |k| json_response['workflow_run'].key? k })
        assert_equal 1_859_445_208, json_response['workflow_run']['id']
      end
    end
  end
end
