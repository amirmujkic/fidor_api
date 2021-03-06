module ClientHelper
  def setup_client
    FidorApi::Client.new do |config|
      config.environment   = environment if defined?(environment)
      config.client_id     = client_id
      config.client_secret = client_secret
      config.logger        = Logger.new('/dev/null') unless ENV['VERBOSE']
    end
  end

  def stub_fetch_request(endpoint:, response_body:, response_headers: {})
    if response_body.is_a? Array
      response_body = {
        data: response_body,
        collection: {
          current_page:  1,
          per_page:      10,
          total_entries: 1,
          total_pages:   1
        }
      }
    end

    response_body = response_body.to_json if response_body.is_a? Hash

    stub_request(:get, endpoint)
      .to_return(status: 200, headers: json_response_header.merge(response_headers), body: response_body)
  end

  def stub_create_request(endpoint:, response_body:, response_headers: {}, status: 201)
    stub_request(:post, endpoint)
      .to_return(
        status: status,
        headers: json_response_header.merge(response_headers),
        body: response_body.to_json
      )
  end

  def stub_update_request(endpoint:, response_body:, response_headers: {}, status: 200)
    stub_request(:put, endpoint)
      .to_return(
        status: status,
        headers: json_response_header.merge(response_headers),
        body: response_body.to_json
      )
  end

  def json_response_header
    { 'Content-Type' => 'application/json' }
  end
end
