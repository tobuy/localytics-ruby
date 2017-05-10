module Localytics
  class Event
    class << self
      attr_accessor :app_id
    end

    # @param event_attributes = Optional hash of up to 50 key/value attribute pairs (up to 50).
    #                           Values must be formatted as strings.
    # @param ltv_change = Optional int representing incremental change in user's lifetime value.
    #                     Must be integer, e.g. use 299 for $2.99.
    def self.send(app_id, customer_id, event_name, event_attributes=nil, ltv_change=nil, api_key=nil, api_secret=nil)
      raise Error.new('No APP id provided') unless app_id ||= self.app_id
      raise Error.new('No customer_id provided') if customer_id.nil?
      raise Error.new('No event_name provided') if event_name.nil? || event_name.empty?

      params = {
        schema_url:  "https://localytics-files.s3.amazonaws.com/schemas/eventsApi/v0.json",
        app_uuid:    app_id,
        customer_id: customer_id.to_s,
        event_name:  event_name,
        event_time:  (Time.now.to_f * 1000).to_i,
        uuid:        SecureRandom.uuid
      }
      params[:attributes] = event_attributes if event_attributes && !event_attributes.empty?
      params[:ltv_change] = ltv_change if ltv_change

      Localytics.request api_base, :post, url, api_key, api_secret, params
    end

    private
    def self.api_base
      "https://analytics.localytics.com/events/v0"
    end

    def self.url
      "/uploads"
    end
  end
end
