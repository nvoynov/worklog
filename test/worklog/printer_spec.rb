require_relative '../test_helper'
require 'date'
include Worklog

describe Printer do
  let(:sheet) {
    this_date = Date.today
    prev_date = this_date << 1
    arch_date = prev_date << 1

    DSL.build do
      title 'Spec'
      date_format '%Y-%m-%d'
      hourly_rate 20

      track arch_date.to_s, spent: '8h', task: 'working on vision document'
      track arch_date.to_s, spent: '2h', task: 'working on vision document'
      track prev_date.to_s, spent: '8h', task: 'working on user stories'
      track prev_date.to_s, spent: '4h', task: 'working on user stories'
      track this_date.to_s, spent: '8h', task: 'working on use cases'
      track this_date.to_s, spent: '6h', task: 'working on use cases'
    end
  }

  let(:decorator) { Decorator.new(sheet) }
  let(:printer)   { Printer.new(decorator) }

  describe '#tracks' do
    it 'must print all tracks report' do
      OStreamCatcher.catch do
        printer.tracks
        printer.this_month
        printer.prev_month
      end
    end
  end

end
