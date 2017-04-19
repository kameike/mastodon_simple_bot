require 'toml'

class BotSetting
  def initialize(file_path)
    @settings = TOML.load_file(file_path)

    if has_random_phrase?
      renew_random_phrase
    end
  end

  def get_random_phrase
    if has_random_phrase?
      begin
        @random_ittr.next
      rescue StopIteration => _
        renew_random_phrase
        @random_ittr.next
      end
    end
  end

  def has_random_phrase?
    if @settings['post'] != nil &&
      @settings['post']['random'] != nil &&
      @settings['post']['random']['interval'] != nil &&
      @settings['post']['random']['phrases'] != nil
      true
    else
      false
    end
  end

  def random_post_interval
    return nil if !has_random_phrase?
    @settings['post']['random']['interval']
  end

  def random_phrases
    return nil if !has_random_phrase?
    @settings['post']['random']['phrases'].split("\n")
  end

  private
  def renew_random_phrase
    if has_random_phrase?
      @random_ittr = random_phrases.shuffle!.each
    end
  end
end
