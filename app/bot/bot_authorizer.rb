require './app/authorizer/mastodon_authorizer.rb'
require './app/authorizer/app_creator.rb'
require './app/authorizer/token_creator.rb'


class BotAuthorizer
  include Singleton
  TOKENS_PATH = "./.tokens.yaml"
  APP_KEYS_PATH = "./.app_keys.yaml"

  def initialize
    @authorizer = MastodonAuthorizer.new(tokens_file: TOKENS_PATH, app_keys_file: APP_KEYS_PATH, app_creator: AppCreator, token_creator: TokenCreator)
  end

  def get_token(**args)
    @authorizer.get_token(**args)
  end

  def save_if_needed
    @authorizer.save_token_if_needed
    @authorizer.save_app_keys_if_needed
  end
end


