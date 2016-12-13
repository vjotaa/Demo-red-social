module Notificable
  extend ActiveSupport::Concern

  included do
    has_many :notifications, as: :item
    after_commit :send_notification_to_users
  end



  def send_notification_to_users
    if self.respond_to? :user_ids
      #JOB => Mandar notificaciones async
      NotificationSenderJob.perform_now(self)
    end
  end

end
