# encoding: UTF-8

require 'delegate'

module Worklog

  class Decorator < SimpleDelegator
    def initialize(sheet)
      @sheet = sheet
      super
    end

    Person = Struct.new(:date, :spent, :task, :reward)

    def tracks(filter = ->(x,_){true})
      items = super().select(&filter)
        .each_with_object([]) do |(date, tary), out|
          out << Person.new(date,
            tary.map(&:spent).inject(:+),
            tary.map(&:task).join(?\n),
            tary.map(&:reward).inject(:+)
          )
        end.sort!{|a, b| a.date <=> b.date}

      {}.tap do |out|
        out[:title] = title
        out[:items] = items
        out[:spent] = items.map(&:spent).inject(:+)
        out[:total] = items.map(&:reward).inject(:+)
      end
    end

    # TODO: this year, previous year?

    def this_month
      tracks(-> (x,_) { x >= start_of_month(Date.today) })
    end

    def prev_month
      till = start_of_month(Date.today) - 1
      from = start_of_month(till)
      tracks(-> (x,_) { x >= from && x <= till })
    end

    def this_week
      today = Date.today
      from = today - today.wday + 1
      tracks(-> (x,_) { x >= from })
    end

    def prev_week
      today = Date.today
      till = today - today.wday # last sunday
      from = till  - 6          # prev monday
      tracks(-> (x,_) { x >= from && x <= till })
    end

    protected

    def start_of_month(date)
      Date.new(date.year, date.month, 1)
    end

    def end_of_month(date)
      Date.new(date.year, date.month, -1)
    end
  end

end
