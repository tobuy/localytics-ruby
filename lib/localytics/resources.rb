require_relative 'operations'

module Localytics
  class Resource
    include Operations

    def self.url id=nil
      resource_name = self.name.split('::').last.downcase
      id ? "/#{resource_name}/#{id}/" : "/#{resource_name}/"
    end

    def self.api_base
      raise 'subclassResponsibility'
    end
  end

  class Profile < Resource
    def self.api_base
      'https://profile.localytics.com/v1/profiles'
    end

    def self.url id=nil
      id ? "/#{id}" : ''
    end

    public_class_method :show, :delete

    def self.create customer_id, params={}, api_key=nil, api_secret=nil
      Localytics.request api_base, :post, url(customer_id), api_key, api_secret, params
    end

    def self.update customer_id, params={}, api_key=nil, api_secret=nil
      Localytics.request api_base, :patch, url(customer_id), api_key, api_secret, params
    end
  end


end