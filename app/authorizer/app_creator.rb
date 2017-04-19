require 'mastodon'
require './app/util/validator.rb'

WEB_BOT_GITHUB_PAGE = "https://github.com/kameike/mastodon_simple_bot"

class BaseAppCreator
  include Validator

  def initialize(**args)
    nil_check_for args, [:host_url, :client_name]
    @host_url = args[:host_url]
    @client_name = args[:client_name]
  end

  def create
    raise "you must implement BaseAppCreator#create as child class"
  end
end

class AppCreator < BaseAppCreator
  def create
    client = Mastodon::REST::Client.new(base_url: @host_url)
    app = client.create_app(@client_name, @host_url, "read write follow", WEB_BOT_GITHUB_PAGE)
    {client_id: app.client_id, client_secret: app.client_secret}
  end
end
 

