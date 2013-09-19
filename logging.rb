require 'terminal-notifier'

module Logging
  def self.included(base)
    base.extend(ClassMethods)
  end

  class Logger
    def log(msg)
      puts msg
      TerminalNotifier.notify(msg)
    end
  end

  module ClassMethods
    def log(notification)
      Logger.new.log(notification)
    end
  end

  def log(notification)
    Logger.new.log notification
  end
end