# frozen_string_literal: true

class OrganizationMailer < ApplicationMailer
  def ownership_transferred(user, organization)
    @user = user
    @organization = organization
    mail(to: user.email, subject: t(".subject", organization: organization.name))
  end
end
