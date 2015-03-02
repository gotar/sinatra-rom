module Credentials
  def api_username
    ENV['API_USER']
  end

  def api_password
    ENV['API_PASSWORD']
  end
end
