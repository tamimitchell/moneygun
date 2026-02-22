# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update]

  def show; end

  def edit; end

  def update
    if @user.update(user_params)
      respond_to do |format|
        format.html { redirect_to user_path }
        format.turbo_stream { render turbo_stream: turbo_stream.redirect_to(user_path) }
      end
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.expect(user: %i[name avatar])
  end
end
