require 'selenium-webdriver'

## USER DEFINED VALUES
$email = "your email here"
$pass = "your password here"
phrases = [
  "フェネックやめるのだ！",
  "フェネックやめるのだ！！！",
  "フェネックやめるのだぁぁ！！",
  "フェネック....フェネックやめるのだぁ！"
]
interval = 60 * 20 # 30min
## USER DEFINED VALUES END


def randomPost(phrases, interval=1800)
  randomPhreases = phrases.shuffle
  randomPhreases.each do |phrase|
    post phrase
    sleep interval
  end
end

def post(phrase)
  driver = Selenium::WebDriver.for :chrome
  driver.get 'https://pawoo.net/auth/sign_in'
  Selenium::WebDriver::Wait.new(:timeout => 5).until do 
    email_input = driver.find_element id: "user_email"
    pass_input = driver.find_element id: "user_password"
    if email_input != nil && pass_input != nil
      email_input.send_keys $email
      pass_input.send_keys $pass
      button = driver.find_element class: "btn"
      button.click
      break true
    else
      break false
    end
  end

  Selenium::WebDriver::Wait.new(:timeout => 20).until do 
    textarea = driver.find_element class: "autosuggest-textarea__textarea"
    if textarea != nil
      textarea.send_keys phrase
      button = driver.find_element class: "button"
      button.click
      driver.quit
      break true
    end 
  end

  driver.quit
end

loop { randomPost phrases, interval }
