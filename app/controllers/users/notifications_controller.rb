# frozen_string_literal: true

class Users::NotificationsController < ApplicationController
  after_action :mark_as_seen, only: [:index]

  def index
    notifications = current_user.notifications.newest_first

    limit = if turbo_frame_request?
              3
            else
              10
            end
    @pagy, @notifications = pagy(notifications, limit:)
  end

  private

  def mark_as_seen
    unseen = @notifications.unseen
    return if unseen.none?

    unseen.mark_as_seen

    Turbo::StreamsChannel.broadcast_update_to(
      "notifications_#{current_user.id}",
      targets: ".notification-badge",
      partial: "shared/notification_badge",
      locals: { count: current_user.notifications.unseen.count }
    )
  end
end
