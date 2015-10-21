module Localytics
  class App

    class << self
      attr_accessor :app_id
    end

    def self.show_app(app_id=nil, api_key=nil, api_secret=nil)
      Localytics.request api_base, :get, url(app_id), api_key, api_secret
    end

    def self.app_attributes(app_id=nil, api_key=nil, api_secret=nil)
      Localytics.request api_base, :get, url(app_id, true), api_key, api_secret
    end

    def self.show_apps(app_id=nil, api_key=nil, api_secret=nil)
      Localytics.request api_base, :get, '', api_key, api_secret
    end

    private
    def self.api_base
      "https://api.localytics.com/v1/apps"
    end

    def self.url(app_id=nil, attributes=nil)
      unless app_id ||= self.app_id
        raise Error.new('No APP id provided')
      end

      url  = "/#{app_id}"

      if attributes
        url = url + "/attributes"
      end

      return url
    end
  end
end
