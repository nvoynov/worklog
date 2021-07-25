# encoding: UTF-8

require 'bigdecimal'
require 'date'
require_relative 'track'

module Worklog
  module Entities

    # This class represent sheet of tracks collection
    class Sheet
      attr_reader :tracks
      attr_accessor :title
      attr_accessor :author
      attr_accessor :source
      attr_accessor :date_format
      attr_accessor :hourly_rate


      def initialize
        @tracks = {}
        @date_format = "%Y-%m-%d"
        @hourly_rate = 0
        @title = ""
      end

      # This method adds new track to the sheet
      # It will pring warning, when total spent for one date exceeds 24h
      # @param date [Date] the track date
      # @param spent [Number] the track spent time in minutes
      # @param task [String] the tracking task description
      # @param rate [Number] the track hourly rate, optional; provide it when the track hourly rate differs from specified for whole sheet (weekends, overtime, or sth)
      # @return [Track] the track registered
      def track(date, spent:, task:, rate: nil)
        @tracks[date] ||= []
        @tracks[date] << Track.new(
          date,
          spent: spent,
          task: task,
          rate: rate || @hourly_rate
        )
        if @tracks[date].size > 1 && spent_for(date) > Track::MAX_MINUTES
          puts "Warning! Total spent for #{date} greater than 24 hours"
        end
        @tracks[date].last
      end

      # The method calculates sum(spent) for provided date
      # @param date [Date] the date for calculation
      # @retun [Number] sum of spent for the date
      def spent_for(date)
        @tracks[date].map(&:spent).inject(:+)
      end

      # The method merges tracks from sheet passed as param
      def merge!(sheet)
        @tracks.merge!(sheet.tracks) do |date, these_tracks, merge_tracks|
          puts "Warning! Date duplication detected in '#{@source}' and '#{sheet.source}'"
          puts "Please, check these files manually for '#{date.to_s}'"
          these_tracks + merge_tracks
        end
      end

    end
  end
end
