module Localytics
  class Profile
    class << self
      attr_accessor :app_id
    end

    def self.create(customer_id, params={}, app_id=nil, api_key=nil, api_secret=nil)
      Localytics.request api_base, :post, url(customer_id, app_id), api_key, api_secret, params
    end

    def self.update(customer_id, params={}, app_id=nil, api_key=nil, api_secret=nil)
      Localytics.request api_base, :patch, url(customer_id, app_id), api_key, api_secret, params
    end

    def self.show(customer_id, app_id=nil, api_key=nil, api_secret=nil)
      Localytics.request api_base, :get, url(customer_id, app_id), api_key, api_secret
    end

    def self.delete(customer_id, app_id=nil, api_key=nil, api_secret=nil)
      Localytics.request api_base, :delete, url(customer_id, app_id), api_key, api_secret
    end

    def self.profiles(customer_id, api_key=nil, api_secret=nil)
      Localytics.request api_base, :get, "/customers/#{customer_id}", api_key, api_secret
    end

    def self.profiles_by_email(customer_email, api_key=nil, api_secret=nil)
      Localytics.request api_base, :get, "/customers?email=#{customer_email}", api_key, api_secret
    end

    private

    def self.api_base
      'https://profile.localytics.com/v1'
    end

    def self.url(id=nil, app_id=nil)
      if app_id ||= self.app_id
        return "/apps/#{app_id}/profiles/#{id}"
      end

      id ? "/profiles/#{id}" : ''
    end
  end
end
