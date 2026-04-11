Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "*" # lock down in production
    resource "/api/*",
      headers: :any,
      methods: [ :get, :post, :put, :patch, :delete, :options ],
      expose: [ "Authorization" ]
  end
end
