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

def test_profiles(params={})
  {
      'id': 'Isa',
      'profiles': [
          {
              'attributes': {
                  'name': 'Isa',
                  'cats': ['Ofelia', 'Mittens', 'Spot', 'Schrödinger'],
                  'age': 30,
                  'lucky numbers': [1, 48, -100, 13],
                  'birthday': '1983-01-01'
              },
              'localytics': {
                  'attributes': {
                      'country': 'us',
                      'city_name': 'Boston',
                      'last_session_date': '2015-01-15'
                  }
              }
          },
          {
              'app_id': 'my_app',
              'attributes': {
                  'high score': 30,
                  'favorite teams': ['Red Sox', 'Yankees']
              },
              'localytics': {
                  'attributes': {
                      'app_version': '3.1',
                      'push_enabled': 1,
                      'custom_1': 'yes'
                  }
              }
          }
      ]

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