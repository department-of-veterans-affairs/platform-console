# rubocop:disable Lint/Syntax
# frozen_string_literal: true

class AuditsController < ApplicationController
  before_action :authorize_session!
  before_action :set_audit, only: %i[show edit update destroy]

  # GET /audits or /audits.json
  def index
    @audits = PaperTrail::Version.all
    @pagy, @audits = pagy(
      @audits.reorder(sort_column => sort_direction),
      items: params.fetch(:count, 25),
      link_extra: 'data-turbo-action="advance"'
    )
  end

  # GET /audits/1 or /audits/1.json
  def show; end

  private

  def sort_column
    %w[created_at].include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end
end
