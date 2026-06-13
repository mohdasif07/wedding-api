module Notifications
  class PushNotificationService
    # Integrate with Firebase Cloud Messaging in production.
    # This service records intent and can be wired to FCM HTTP v1 API.
    def initialize(user:, title:, body:, data: {})
      @user = user
      @title = title
      @body = body
      @data = data
    end

    def call
      tokens = user.device_tokens.pluck(:token)
      return { success: false, errors: ["No device tokens registered"] } if tokens.empty?

      Rails.logger.info("[FCM] Sending to #{tokens.size} devices: #{title} - #{body}")
      # FCM integration placeholder - configure FIREBASE_SERVER_KEY in production
      { success: true, sent_to: tokens.size }
    end

    private

    attr_reader :user, :title, :body, :data
  end
end
