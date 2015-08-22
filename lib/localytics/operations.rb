module Localytics
  module Operations
    module ClassMethods

      private

      def create params={}, api_key=nil, api_secret=nil
        Localytics.request api_base, :post, url, api_key, api_secret, params
      end

      def list params={}, api_key=nil, api_secret=nil
        Localytics.request api_base, :get, url, api_key, api_secret,  params
      end

      def show uid, params={}, api_key=nil, api_secret=nil
        require_uid uid
        Localytics.request api_base, :get, url(uid), api_key, api_secret, params
      end

      def update uid, params={}, api_key=nil, api_secret=nil
        require_uid uid
        Localytics.request api_base, :patch, url(uid), api_key, api_secret, params
      end

      def delete uid, params={}, api_key=nil, api_secret=nil
        require_uid uid
        Localytics.request api_base, :delete, url(uid), api_key, api_secret, params
      end

      def delete_all params={}, api_key=nil, api_secret=nil
        Localytics.request api_base, :delete, url, api_key, api_secret, params
      end

      def require_uid uid
        raise Error.new('UID is required') if uid.nil? || uid == ''
      end

    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end