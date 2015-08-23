require 'securerandom'

module Localytics
  class Push

    class << self
      attr_accessor :app_id
    end

    # Generic method to send push notifications thru Localytics.
    # Mandatory parameters:
    # * :messages an array containing the push messages to send.
    # * :target_type targeted resource. Available values are:
    #     :customer_id
    #     :broadcast
    #     :profile
    #     :audience_id
    # Optional attributes are:
    # * :api_key
    # * :api_secret
    # * :headers
    #
    # More information on how messages can be built can be found on
    # http://docs.localytics.com/#Dev/getting-started-trans-push.html
    def self.push(messages, target_type, app_id=nil, api_key=nil, api_secret=nil, headers={})
      Localytics.request(
          api_base(app_id),
          :post,
          '',
          api_key,
          api_secret,
          {
              messages: messages,
              target_type: target_type,
              campaign_key: nil,
              request_id: SecureRandom.uuid
          },
          headers
      )
    end

    # For :messages options please check the :push method
    def self.push_to_customers(messages, app_id=nil, api_key=nil, api_secret=nil)
      push messages, 'customer_id', app_id, api_key, api_secret
    end

    # For :messages options please check the :push method
    def self.push_to_all_customers(messages, app_id=nil, api_key=nil, api_secret=nil)
      push messages, 'broadcast', app_id, api_key, api_secret
    end

    # For :messages options please check the :push method
    def self.push_to_profiles(messages, app_id=nil, api_key=nil, api_secret=nil)
      push messages, 'profile', app_id, api_key, api_secret
    end

    def self.push_to_audiences(messages, app_id=nil, api_key=nil, api_secret=nil)
      push messages, 'audience_id', app_id, api_key, api_secret
    end

    private

    def self.api_base app_id
      unless app_id ||= self.app_id
        raise Error.new('No APP id provided')
      end

      "https://messaging.localytics.com/v2/push/#{app_id}"
    end
  end
end