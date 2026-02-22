# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    redirect_to default_authenticated_path, allow_other_host: false
  end
end
