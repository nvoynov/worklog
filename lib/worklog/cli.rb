# encoding: UTF-8

require 'thor'
require_relative 'services'
include Worklog::Services

module Worklog

  class CLI < Thor
    include Thor::Actions
    namespace :worklog

    no_commands {
      def under_construction
        say "this feature is under construction at the moment"
      end

      def get_logs
        if Dir.glob(Worklog::LOGMASK).empty?
          say "No *.timelog files were found in this directory"
          say "Run '$ timelog new'"
          exit
        end

        Worklog.indexd
        GetWorklogs.()
      end
    }

    desc "version", "Show Worklog version"
    def version
      puts "Worklog v#{Worklog::VERSION}"
    end
    map %w[--version -v] => :version

    desc "new [LOGNAME]", "Create timelog file LOGNAME the working directory"
    def new(logname = File.basename(Dir.pwd))
      filename = CreateLog.(logname)
      exit if filename.empty?
      say "Worklog #{filename} created"
      Worklog.indexd
    end

    desc "get", "Show timelog report of the working directory"
    def get
      get_logs.each{|sh| Printer.new(Decorator.new(sh)).tracks()}
    end

    desc "this [PERIOD=month]", "Show timelog for this PERIOD (month/week)"
    def this(period = "month")
      get_logs.each do |sh|
        printer = Printer.new(Decorator.new(sh))
        case period
        when 'month'
          printer.this_month
        when 'week'
          printer.this_week
        else
          raise ArgumentError, "Unknown period '#{period}'"
        end
      end
    end

    desc "prev [PERIOD=month]", "Show timelog for prev PERIOD (month/week)"
    def prev(period = "month")
      get_logs.each do |sh|
        printer = Printer.new(Decorator.new(sh))
        case period
        when 'month'
          printer.prev_month
        when 'week'
          printer.prev_week
        else
          raise ArgumentError, "Unknown period '#{period}'"
        end
      end
    end

    desc "index", "Show all known timelog directories"
    def index
      str = Worklog.params[:index].map{|i| "- #{i}"}.join(?n)
      say "Worklogs were noticed in the following places:\n#{str}"
    end


  end

end
