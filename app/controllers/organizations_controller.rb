# frozen_string_literal: true

class OrganizationsController < ApplicationController
  include OrganizationPrefill

  layout "centered", only: %i[new create]

  before_action :set_organization, only: %i[show edit update destroy]

  def index
    @pagy, @organizations = pagy(current_user.organizations.with_logo.includes(:users, :memberships, :sent_invitations, :received_join_requests))
  end

  def show; end

  def new
    @organization = Organization.new

    if params[:website].present?
      prefill_organization_from_website(@organization, params[:website])
      @show_form = true
    elsif params[:skip].present?
      @show_form = true
    end
  end

  def edit; end

  def create
    @organization = Organization.new(organization_params)
    @organization.owner = current_user

    if @organization.save
      redirect_to organization_path(@organization)
    else
      @show_form = true
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @organization.update(organization_params)
      respond_to do |format|
        format.html { redirect_to edit_organization_path(@organization) }
      end
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    if @organization.destroy
      flash[:notice] = t(".success")
      redirect_to organizations_path
    else
      flash[:alert] = t(".error")
      redirect_to organization_path(@organization)
    end
  end

  private

  def set_organization
    @organization = current_user.organizations.find(params[:id])
    Current.membership = current_user.memberships.find_by(organization: @organization)
    Current.organization = Current.membership&.organization
    authorize @organization
  rescue ActiveRecord::RecordNotFound
    redirect_to default_authenticated_path, alert: t("shared.errors.not_authorized")
  end

  def organization_params
    params.expect(organization: %i[name logo privacy_setting website])
  end

  def pundit_user
    Current.membership || super
  end
end
