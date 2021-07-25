# encoding: UTF-8

require_relative 'entities'
include Worklog::Entities

module Worklog

  # This class provides DSL for timelogging
  #
  # @example
  #   sheet = DSL.build() do
  #     title "Worklog"
  #     date_format "%Y-%m-%d"
  #     hourly_rate 20
  #
  #     track '2021-07-10', spent: '8h', task: 'work on func requirements'
  #     track '2021-07-11', spent: '8h', task: 'work on func requirements'
  #     track '2021-07-12', spent: '8h30m', task: 'work on use cases'
  #     track '2021-07-13', spent: '30m', task: 'work on user stories'
  #     track '2021-07-13', spent: '7h30m', task: 'administrator user stories'
  #   end
  #
  # @example
  #   sheet = DSL.build() { read File.read('project.timesheet') }
  class DSL
    attr_reader :sheet

    def self.build(&block)
      dsl = new
      dsl.instance_eval(&block) if block_given?
      dsl.sheet
    end

    private_class_method :new

    def initialize
      @sheet = Sheet.new
    end

    def title(title)
      @sheet.title = title
    end

    def author(author)
      @sheet.author = author
    end

    def date_format(fmt)
      @sheet.date_format = fmt
    end

    def hourly_rate(rate)
      @sheet.hourly_rate = rate
    end

    def read(text)
      instance_eval text
    end

    def read_file(filename)
      text = File.read(filename)
      read text
      @sheet.source = filename
    end

    def track(date, spent:, task: '', rate: nil)
      @sheet.track(
        Date.strptime(date, @sheet.date_format),
        spent: parse_spent(spent),
        rate: rate,
        task: task
      )
    end

    def parse_spent(time)
      regx = /^((\d{1,2})[hH])?\s?((\d{1,2})[mM])?$/
      data = time.match(regx)
      raise ArgumentError, "\"spent\" format \"\d{1,2}[Hh]d{1,2}[Mm]\"" unless data
      h = data[2] || 0
      m = data[4] || 0
      h.to_i * 60 + m.to_i
    end
  end

end
