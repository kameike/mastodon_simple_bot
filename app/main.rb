require './app/bot/bot.rb'
require './app/bot/toot_scheduler.rb'
require './app/util/validator.rb'
require 'toml'

module Main 
  extend Validator

  BOT_ACCOUNT_PATH = "./account.toml"

  def self.main 
    load_bots
    @bots.each do |bot|
      puts "start bot #{bot.name}"
      TootScheduler.instance.add_bot(bot)
    end
    # load_bots_setting
    # start
  end

  def start
    @bot.filer(&:is_ready).each(&:start)
  end

  def load_bots_setting
    @bots.each do |bot|
      begin
        bot.load_setting
      rescue => _
      end
    end
  end

  def self.load_bots
    account_data = TOML.load_file(BOT_ACCOUNT_PATH)
    bots = account_data["account"].map do |attr|
      nil_check_for attr, ["email", "name", "password", "host_url", "setting_file"]

      Bot.new(
        email: attr["email"],
        password: attr["password"],
        host_url: attr["host_url"],
        setting_file: attr["setting_file"],
        client_name: attr["client_name"],
        name: attr["name"]
      )
    end
    BotAuthorizer.instance.save_if_needed
    @bots = bots
  end
end

Main.main()
sleep
