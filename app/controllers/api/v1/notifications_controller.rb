module Api
  module V1
    class NotificationsController < BaseController
      def index
        notifications = current_user.notifications.recent
        result = paginate(notifications)
        render json: result[:data], each_serializer: NotificationSerializer,
               meta: result[:meta].merge(unreadCount: current_user.notifications.unread.count)
      end

      def mark_read
        notification = current_user.notifications.find(params[:id])
        notification.update!(read: true)
        render json: notification, serializer: NotificationSerializer
      end

      def read_all
        current_user.notifications.unread.update_all(read: true)
        render json: { message: "All notifications marked as read" }
      end
    end
  end
end
