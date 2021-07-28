# encoding: UTF-8

require 'delegate'

module Worklog

  class Printer < SimpleDelegator
    def initialize(sheet)
      @sheet = sheet
      super
    end

    # TODO: header for this/prev month/week
    # TODO: grouping by months if there are more than one
    def print(report, subtitle = "")
      puts "-= #{report[:title]} #{subtitle} =-"
      puts %w(Date Year Month Week Spent Reward Task).join(?\t)
      report[:items].each do |track|
        row = [].tap do |r|
          r << track.date.to_s
          r << track.date.year
          r << track.date.strftime('%B')
          r << track.date.cweek
          r << format_spent(track.spent)
          r << track.reward.to_s(?F)
          r << track.task
        end.join(?\t)
        puts row
      end
      puts
      puts "Total time\t#{format_spent(report[:spent])}"
      puts "Total\t%.2f" % report[:total]
    end

    def tracks(filter = ->(x,_){true})
      print(super(&filter))
    end

    def this_month
      subtitle = "for #{Date.today.strftime("%B %Y")}"
      print(super(), subtitle);
    end

    def prev_month
      subtitle = "for #{(Date.today << 1).strftime("%B %Y")}"
      print(super(), subtitle)
    end

    def this_week
      subtitle = this_week_title
      print(super(), subtitle)
    end

    def prev_week
      subtitle = prev_week_title
      print(super(), subtitle)
    end

    protected

      def this_week_title
        today = Date.today
        from = today - (today.wday - 1) % 7
        "from #{from} till #{today}"
      end

      def prev_week_title
        today = Date.today
        from = today - 7 - (today.wday - 1) % 7
        till = from + 6
        "from #{from} till #{till}"
      end

      def format_spent(spent)
        h = spent / 60
        m = spent % 60
        [].tap do |out|
          out << "#{h}h" if h > 0
          out << "#{m}m" if m > 0
        end.join(" ")
      end

  end

end
