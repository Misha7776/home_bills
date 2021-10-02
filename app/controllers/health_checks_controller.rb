class HealthChecksController < ApplicationController
  skip_before_action :authenticate_user!

  def check
    head :ok
  end
end
