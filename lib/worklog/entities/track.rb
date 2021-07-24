# encoding: UTF-8

require 'bigdecimal'
require 'date'

module Worklog
  module Entities

    # This class represent the abstraction of a timelog item
    class Track
      attr_reader :date
      attr_reader :rate
      attr_reader :task
      attr_reader :spent
      attr_reader :reward

      # @param date [Time] the date of the track
      # @param rate [Float] the rate of the track
      # @param spent [Integer] minutes spent of the track
      # @param task [String] the task descritpion of the track
      def initialize(date, spent:,  rate: 0, task: "")
        # the spent cannot be more than a day of 24 hours
        raise ArgumentError, ":spent exceeds 24 hours" if spent > MAX_MINUTES
        # the date cannot be in the future
        date = date.to_date unless date.is_a? Date
        raise ArgumentError, ":date in the future" if date > Date.today
        @date = date
        @rate = rate
        @task = task
        @spent = spent
        reward = BigDecimal(spent.to_s) / BigDecimal(60) * BigDecimal(rate.to_s)
        @reward = reward.round(2, :half_down)
      end

      MAX_MINUTES = 1440
    end
  end
end
