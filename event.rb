class Event
  attr_accessor :complete, :idx
  attr_reader :bot,:msg

  @@events = []
  @@messages = ['What is your event called?','Where will you event be?','Description','start time?','end time?']
  @@keys = [:summary, :location, :description, [:start, :date_time], [:end, :date_time]]

  def initialize(msg,bot)
    @msg = msg
    @bot = bot
    idx = 0
    # add_event(@idx)
    @@events << self
  end

  def self.all
    @@events
  end

  def event
    {summary: '',
     location: '',
     description: '',
     start: {
       date_time: '',
       time_zone: 'America/Los_Angeles',
     },
     end: {
       date_time: '',
       time_zone: 'America/Los_Angeles',
     }
    }
  end

  def add_event_detail(idx,msg)
    @@keys[idx].is_a?(Array) ? @@events[@@keys[idx][0]][@@keys[idx][1]] = msg.text : @@events[@@keys[idx]] = msg.text
    idx + 1
    @bot.api.send_message(chat_id: msg.chat.id, parse_mode: 'HTML',
                          text: @@messages[idx])
  end

  def incomplete?
    binding.pry
      self.event[:end][:date_time].empty? && @@events.count > 0
  end
 
end
