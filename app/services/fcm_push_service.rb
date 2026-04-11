class FcmPushService
  FCM_URL = "https://fcm.googleapis.com/v1/projects/%s/messages:send".freeze

  def self.send_push(device_token:, title:, body:, data: {})
    project_id = Rails.application.credentials.dig(:firebase, :project_id)
    return unless project_id

    payload = {
      message: {
        token: device_token,
        notification: { title: title, body: body },
        data: data.transform_values(&:to_s)
      }
    }

    uri = URI(format(FCM_URL, project_id))
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path)
    request["Authorization"] = "Bearer #{access_token}"
    request["Content-Type"] = "application/json"
    request.body = payload.to_json

    response = http.request(request)
    Rails.logger.info("FCM push response: #{response.code} #{response.body}")
    response
  rescue StandardError => e
    Rails.logger.error("FCM push error: #{e.message}")
    nil
  end

  def self.access_token
    credentials_path = Rails.application.credentials.dig(:firebase, :credentials_path)
    return nil unless credentials_path

    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open(credentials_path),
      scope: "https://www.googleapis.com/auth/firebase.messaging"
    )
    authorizer.fetch_access_token!
    authorizer.access_token
  rescue StandardError => e
    Rails.logger.error("FCM auth error: #{e.message}")
    nil
  end
end
