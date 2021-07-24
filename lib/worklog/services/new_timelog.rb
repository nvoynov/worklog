# encoding: UTF-8

require_relative 'service'
require 'date'

module Worklog
  module Services
    include Worklog

    # This service creates timelog file in the working directory.
    #  and returns name of the created file '<folder_name>.timelog'
    #  If file with this name exits
    # @example
    class NewWorklog < Service
      def call
        filename = @logname + Worklog::LOGMASK[1..-1]
        if File.exist? filename
          puts "Operation canceled. File with name '#{filename}' already exists"
          return ''
        end
        File.write(filename, LOGCONTENT % [@logname, Date.today.to_s])
        filename
      end

      def initialize(logname)
        @logname = logname
      end

      LOGCONTENT = <<~EOF
        title %s
        hourly_rate 20
        date_format '%%Y-%%m-%%d'

        track '%s', spent: '1h', task: 'created timelog ..'
      EOF

    end

  end
end
