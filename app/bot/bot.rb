require 'time'
require 'mastodon'
require './app/bot/bot_authorizer.rb'
require './app/bot/bot_setting.rb'
require './app/util/validator.rb'

class Bot
  include Validator

  attr_reader :name
  attr_reader :access_token
  attr_reader :setting

  def initialize(**args)
    nil_check_for args, [:name, :email, :password, :host_url, :setting_file]
    args[:client_name] = 'simple bot' if args[:client_name] == nil
    @name = args[:name]

    @access_token = BotAuthorizer.instance.get_token(
      client_name: args[:client_name],
      host_url: args[:host_url],
      password: args[:password],
      email: args[:email]
    )
    @client = Mastodon::REST::Client.new(base_url: 'https://pawoo.net', bearer_token: @access_token)
    @self_account = @client.verify_credentials
    @setting = BotSetting.new(args[:setting_file])
  end

  def post phrase
    @client.create_status phrase
  end

  def last_post_time
    last_stauses = @client.statuses @self_account.id
    last_stauses.reduce Time.new(0) do |time, state|
      new_time = Time.parse(state.created_at)
      if  new_time > time
        new_time
      else
        time
      end
    end
  end
end
