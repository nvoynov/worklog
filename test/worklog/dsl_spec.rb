require_relative '../test_helper'
include Worklog

describe DSL do
  describe '#call' do
    it 'must return Sheet' do
      sheet = DSL.build()
      _(sheet).must_be_instance_of Sheet
    end
  end

  describe '#title' do
    it 'must set sheet title' do
      sheet = DSL.build() { title "Spec Title" }
      _(sheet.title).must_equal "Spec Title"
    end
  end

  describe '#date_format' do
    it 'must set sheet date_format' do
      sheet = DSL.build() { date_format "Spec Format" }
      _(sheet.date_format).must_equal "Spec Format"
    end
  end

  describe '#hourly_rate' do
    it 'must set sheet hourly_rate' do
      sheet = DSL.build() { hourly_rate 25 }
      _(sheet.hourly_rate).must_equal 25
    end
  end

  describe '#parse_spent' do

    class SpecDSL < DSL
      def self.spec
        new
      end
    end

    let(:dsl) { SpecDSL.spec }

    it 'must return total minutes' do
      _(dsl.parse_spent('8h')).must_equal  8 * 60
      _(dsl.parse_spent('08h')).must_equal 8 * 60
      _(dsl.parse_spent('05m')).must_equal 5
      _(dsl.parse_spent('50m')).must_equal 50
      _(dsl.parse_spent('3H30m')).must_equal 210
    end

    it 'must raise ArgumentError' do
      _(-> { dsl.parse_spent('24P01m') }).must_raise ArgumentError
    end
  end

  describe '#read' do
    let(:dsl) {
      <<~DSL
        title "Nikolai Voinov timesheet on Fedoriv"
        date_format "%Y-%m-%d"
        hourly_rate 20

        track '2021-07-10', spent: '8h', task: 'work on func requirements'
        track '2021-07-11', spent: '8h', task: 'work on func requirements'
        track '2021-07-12', spent: '8h30m', task: 'work on use cases'
        track '2021-07-13', spent: '30m', task: 'work on user stories'
        track '2021-07-14', spent: '2h30m', task: 'work on user stories', rate: 30
      DSL
    }

    it 'must read DSL' do
      txt = dsl
      DSL.build() { read txt }
    end

    # TODO: the idea is report on errors and skip sheet with errors
    #       when it reads it from text or fies
    it 'must catch errors' do
      # reader = ->(txt) { DSL.build() { read txt } }
      # reader.call("title bla-bla-bla")
    end
  end

end
