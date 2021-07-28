# encoding: UTF-8

require_relative 'service'
require_relative '../dsl'

module Worklog
  module Services
    include Worklog

    # This service loads all timelogs in the working directory. Several
    # timelogs that share the same title will be merged to single sheet
    # with the shared title
    # @example
    #   GetLogsWorkDir.() # => Array<Sheet>
    class GetWorklogs < Service

      def call
        [].tap do |logs|
          Dir.glob(::LOGMASK) do |f|
            puts "Processing #{f}.."
            flog = DSL.build() { read_file(f) }
            # merge by sheet title
            mlog = logs.find{|i| i.title == flog.title}
            mlog.nil? ? logs << flog : mlog.merge!(flog)
          end
        end
      end

    end

  end
end
