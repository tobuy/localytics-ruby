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

def test_show_apps(params={})
  {
    "_embedded": {
      "apps": [
        {
          "name": "App Name",
          "app_id": "umdois",
          "created_at": "2012-04-10T04:07:13Z",
          "_links": {
            "self": { "href": "/v1/apps/umdois" },
            "apps": { "href": "/v1/apps" },
            "query": {
              "templated": true,
              "href": "/v1/apps/umdois/query{?app_id,metrics,dimensions,conditions,limit,order,days,comment,translate}"
            },
            "root": { "href": "/v1" }
          }
        }
      ]
    },
    "_links": {
      "self": { "href": "/v1/apps" },
      "root": { "href": "/v1" }
    }
  }
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


def test_apps_attributes()
  {
    "events": [
      {
        "event_name": "Clicked Link",
        "attributes": [ "link_text", "link_target", "link_placement" ],
        "high_cardinality_attributes": [ "link_text" ]
      },
      {
        "event_name": "Added to Cart",
        "attributes": [ "item_name", "item_id" ],
        "high_cardinality_attributes": [ "item_name", "item_id" ]
      }
    ],
    "_links": {
      "app": { "href": "/v1/apps/umdois" },
      "root": { "href": "/v1" }
    }
  }
end

def test_show_app()
  app_info = test_show_apps.delete(:_embedded)[:apps][0]

  more_info = {
    "stats": {
      "sessions": 52291,
      "closes": 46357,
      "users": 7008,
      "events": 865290,
      "data_points": 963938,
      "platforms": ["HTML5"],
      "client_libraries": ["html5_2.6", "html5_2.5", "html5_2.4"],
      "begin_date": "2013-08-10",
      "end_date": "2013-09-10"
    },
    "icon_url": "https://example.com/app-icon.png",
    "custom_dimensions": {
      "custom_0_dimension": "Blood Type",
      "custom_1_dimension": "Moon Phase"
    }
  }

  app_info.merge(more_info)
end

def bad_request
  json = {
      'errors' => [{
                       '4051' => 'Bad Request: The request could not be understood by the server due to malformed syntax.'
                   }]
  }
  RestClient::Exception.new(test_response(json, 404), 400)
end
