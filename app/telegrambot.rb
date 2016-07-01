require 'telegram/bot'
require_relative 'quickstart.rb'
require_relative 'event.rb'

token = '223993681:AAFeNe87yW5ZuGS9qE79MwXxxPbnL_o0jq8'

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when 'hello','hi','hey'
      bot.api.send_message(chat_id: message.chat.id, parse_mode: 'HTML',
                           text: "Hello, #{message.from.first_name}!\nWould you like to hear your schedule for today?")
    when 'today','yes'
      bot.api.send_message(chat_id: message.chat.id, parse_mode: 'HTML',
                           text: "#{GoogleCalendar.get_items('today')}")
    when 'tomorrow'
      bot.api.send_message(chat_id: message.chat.id, parse_mode: 'HTML',
                           text: "#{GoogleCalendar.get_items('tomorrow')}")
    when 'week','whole week'
      bot.api.send_message(chat_id: message.chat.id, parse_mode: 'HTML',
                           text: "#{GoogleCalendar.get_items('week')}")
    when 'new event','add event'
      @@new_event = Event.new(message,bot)
      bot.api.send_message(chat_id: message.chat.id, parse_mode: 'HTML',
                          text: 'What is your event called?')
    when message.text && (message.text != 'new event') && (defined?(@@new_event) != nil) && (@@new_event.incomplete? == true)
      binding.pry
      i ||= 0
      i += 1
      binding.pry
      @new_event.add_event_detail(i,message)
    end
  end
end
