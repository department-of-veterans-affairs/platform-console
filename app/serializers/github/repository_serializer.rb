# frozen_string_literal: true

module Github
  class RepositorySerializer < ::BaseSerializer
    set_id :repo
    attributes :repo, :github, :app_id

    has_many :workflows, id_method_name: :workflow_ids, links: {
      related: lambda { |repository|
        "#{ENV['BASE_URL']}/api/v1/teams/#{team_id_from_app_id(repository.app_id)}/apps/#{repository.app_id}/workflows"
      }
    }
  end
end
