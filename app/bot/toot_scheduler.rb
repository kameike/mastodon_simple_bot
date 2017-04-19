require 'time'
require './app/bot/bot.rb'
require 'rufus-scheduler'
require './app/util/validator.rb'

class TootScheduler
  include Singleton
  include Validator

  def initialize
    @bots = {}
  end 

  def add_bot(bot)
    @bots[bot.access_token] = {bot: bot, scheduler: Rufus::Scheduler.new}
    activate_random_post_for bot if bot.setting.has_random_phrase?
  end

  private
  def activate_random_post_for(bot)
    current_time =  Time.new()
    last_post_time = bot.last_post_time
    interval = bot.setting.random_post_interval

    start_in = interval - (current_time - last_post_time)
    start_in = 1 if start_in < 0

    scheduler = @bots[bot.access_token][:scheduler]

    scheduler.in start_in do
      make_post bot
      scheduler.every interval do 
        make_post bot
      end
    end
  end

  private
  def make_post(bot)
    phrase = bot.setting.get_random_phrase
    begin
      bot.post phrase
      puts "#{Time.new()}|POST:'#{phrase}' by #{bot.name}"
    rescue => _
      puts "#{Time.new()}|POST:'#{phrase}' by #{bot.name}"
    end
  end
end
