# frozen_string_literal: true

module Noticed::NotificationExtensions
  extend ActiveSupport::Concern

  def broadcast_update_to_bell
    broadcast_update_to(
      "notifications_#{recipient.id}",
      targets: ".notification-badge",
      partial: "shared/notification_badge",
      locals: { count: recipient.unseen_notifications_count }
    )
  end

  def broadcast_prepend_to_index_list
    broadcast_prepend_to(
      "notifications_index_list_#{recipient.id}",
      target: "notifications",
      partial: "users/notifications/notification",
      locals: { notification: self }
    )
  end
end
