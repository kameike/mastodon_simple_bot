require 'spec_helper'
require './app/bot/bot_setting.rb'

describe "Bot setting loader" do
  it "can road correct setting file" do
    setting = BotSetting.new("./spec/data/bot_setting.toml")
    expect(setting.has_random_phrase?).to be true
    expect(setting.random_phrases.size).to be 4
    expect(setting.random_post_interval).to be 30
  end

  it "return random phrase nicely" do
    setting = BotSetting.new("./spec/data/bot_setting.toml")
    random_result = (1..(setting.random_phrases.size) * 10).map do
      setting.get_random_phrase
    end
    
    expect(random_result.find_all{|v| "phrase1".eql? v }.size).to eq 10
    expect(random_result.find_all{|v| "phrase2".eql? v }.size).to eq 10
    expect(random_result.find_all{|v| "phrase3".eql? v }.size).to eq 10
    expect(random_result.find_all{|v| "phrase4".eql? v }.size).to eq 10
  end
end

