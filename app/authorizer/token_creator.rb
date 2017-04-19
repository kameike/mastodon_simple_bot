require 'oauth2'
require './app/util/validator.rb'

class BaseTokenCreator
  include Validator
  def initialize(**args)
    nil_check_for args, [:client_id, :client_secret, :host_url, :email, :password]
    @client_id = args[:client_id]
    @client_secret = args[:client_secret]
    @host_url = args[:host_url]
    @email = args[:email]
    @password = args[:password]
    create
  end

  protected def create()
    raise "BaseTokenCreator#create must be overrode by subclass"
  end
end

class TokenCreator < BaseTokenCreator
  def create()
    client = OAuth2::Client.new(@client_id, @client_secret, site: @host_url)
    result =client.password.get_token( @email, @password, redirect_uri: @host_url, scope: 'read write')
    result.token
  end
end

