require 'rest_client'
require 'json'
require 'base64'
require_relative 'localytics/profile'
require_relative 'localytics/push'
require_relative 'localytics/app'

module Localytics
  class Error < StandardError
    include Enumerable
    attr_accessor :errors

    def initialize message, errors={}
      super message
      @errors = errors
    end

    # Yield [error_code, message] pairs
    def each
      @errors.each { |e| yield *e.first }
    end
  end

  class << self
    attr_accessor :api_key, :api_secret
  end

  def self.request(api_base, method, url, api_key=nil, api_secret=nil, params={}, headers={})
    method = method.to_sym

    url = api_base + url

    unless api_key ||= @api_key
      raise Error.new('No API key provided')
    end

    unless api_secret ||= @api_secret
      raise Error.new('No API secret provided')
    end

    unless method == :get
      payload = JSON.generate(params)
      params = nil
    end

    auth = 'Basic ' + Base64.strict_encode64("#{api_key}:#{api_secret}")

    headers = {
        :params => params,
        :content_type => 'application/json',
        :accept => 'application/json',
        :authorization => auth

    }.merge(headers)

    options = {
        :headers => headers,
        :method => method,
        :url => url,
        :payload => payload
    }

    begin
      response = execute_request(options)
      return {} if response.code == 204 and method == :delete
      JSON.parse(response.body, :symbolize_names => true)
    rescue RestClient::Exception => e
      handle_errors e
    end
  end

  private

  def self.execute_request(options)
    RestClient::Request.execute(options)
  end

  def self.handle_errors exception
    body = JSON.parse exception.http_body
    raise Error.new(exception.to_s, body['errors'])
  end

end
