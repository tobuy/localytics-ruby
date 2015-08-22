module Localytics
  @mock_rest_client = nil

  def self.mock_rest_client=(mock_client)
    @mock_rest_client = mock_client
  end

  def self.execute_request(options)
    case options[:method]
      when :get
        @mock_rest_client.get options[:url], options[:headers][:params]
      when :post
        @mock_rest_client.post options[:url], options[:payload]
      when :patch
        @mock_rest_client.patch options[:url], options[:payload]
      when :delete
        @mock_rest_client.delete options[:url]
    end
  end
end

Response = Struct.new :body, :code

def test_response body, code=200
  Response.new JSON.generate(body), code
end

def test_profile(params={})
  {
      attributes: {
          '$first_name' => 'Tester',
          '$last_name' => 'Localytics',
          '$email' => 'tester@localytics.com'
      },
      localytics: {
          attributes: {
              last_session_date: '2015-08-21',
              device_timezone: '-03:00',
              country: 'ar',
              language: 'es',
              user_type: 'known'
          }
      }
  }.merge(params)
end

def profile_params
  {
      attributes: {
          '$email' => 'test@localytics.com',
          '$first_name' => 'Tester Sister',
          '$last_name' => 'Localytics'
      }
  }
end

def bad_request
  json = {
      'errors' => [{
                       '4051' => 'Bad Request: The request could not be understood by the server due to malformed syntax.'
                   }]
  }
  RestClient::Exception.new(test_response(json, 404), 400)
end