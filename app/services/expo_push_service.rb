class ExpoPushService
  EXPO_PUSH_URL = "https://exp.host/--/api/v2/push/send".freeze

  def self.send_push(device_token:, title:, body:, data: {})
    send_batch([{
      to: device_token,
      title: title,
      body: body,
      data: data.transform_values(&:to_s),
      sound: "default"
    }])
  end

  def self.send_batch(messages)
    return if messages.empty?

    uri = URI(EXPO_PUSH_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    # Expo supports up to 100 messages per request
    messages.each_slice(100) do |batch|
      request = Net::HTTP::Post.new(uri.path)
      request["Content-Type"] = "application/json"
      request["Accept"] = "application/json"
      request.body = batch.to_json

      response = http.request(request)
      Rails.logger.info("Expo push response: #{response.code} #{response.body}")
    end
  rescue StandardError => e
    Rails.logger.error("Expo push error: #{e.message}")
    nil
  end
end
