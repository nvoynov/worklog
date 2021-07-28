require_relative '../test_helper'
require 'date'
include Worklog::Entities

describe Sheet do
  let(:sheet) { Sheet.new }
  let(:today) { Date.today }

  describe '#new' do
    it 'must setup attibutes' do
      # sheet = Sheet.new
      _(sheet.tracks).must_equal({})
    end
  end

  describe '#track' do

    it 'must add a new track to @tracks[data]' do
      t1 = sheet.track(today, spent: 60, task: 'spec')
      _(sheet.tracks.keys.size).must_equal 1
      _(sheet.tracks[t1.date].size).must_equal 1

      t2 = sheet.track(t1.date, spent: 60, task: 'spec')
      _(sheet.tracks.keys.size).must_equal 1
      _(sheet.tracks[t2.date].size).must_equal 2

      t3 = sheet.track(t1.date - 1, spent: 60, task: 'spec')
      _(sheet.tracks.keys.size).must_equal 2
      _(sheet.tracks[t3.date].size).must_equal 1
    end

    it 'must add a new track with :rate' do
      t = sheet.track(today, spent: 60, task: 'spec', rate: 20)
      _(t.rate).must_equal 20
    end

    it 'must add a new track with :hourly_rate'  do
      sheet.hourly_rate = 25
      t = sheet.track(today, spent: 60, task: 'spec')
      _(t.rate).must_equal 25
    end

    it 'must warning for more than 24h' do
      sheet.track(today, spent: 1400, task: 'spec')
      _( -> {sheet.track(today, spent: 1400, task: 'spec')}
      ).must_output(/Warning! Total spent/)
    end
  end

  describe '#spent_for' do
    it 'must calculate spent for one date' do
      sheet.track(today, spent: 45, task: 'spec')
      sheet.track(today, spent: 45, task: 'spec')
      _(sheet.spent_for(today)).must_equal 90
    end
  end

  describe '#merge!' do

    let(:sheet) {
      Sheet.new.tap do |sh|
        sh.source = "1.timelog"
        sh.hourly_rate = 20
        sh.date_format = "%Y-%m-%d"
        sh.track today - 2, spent: 90, task: 'spec 1.1'
        sh.track today - 1, spent: 90, task: 'spec 1.2'
      end
    }

    let(:other) {
      Sheet.new.tap do |sh|
        sh.source = "2.timelog"
        sh.hourly_rate = 20
        sh.date_format = "%Y-%m-%d"
        sh.track today, spent: 90, task: 'spec 2.2'
      end
    }

    it 'must merge tracks' do
      sheet.merge!(other)
      _(sheet.tracks.size).must_equal 3
    end

    it 'must warning when merged tracks share the same track.date' do
      sheet.track today, spent: 90, task: 'spec 1.3'
      _(-> {sheet.merge!(other)}).must_output (/^Warning[\S\s]*1.timelog[\S\s]*2.timelog[\S\s]*#{today.to_s}/)
    end
  end

  describe 'total' do
    let(:sheet) {
      Sheet.new.tap do |sh|
        sh.hourly_rate = 20
        sh.track today - 1, spent: 90, task: '1'
        sh.track today, spent: 90, task: '2'
        sh.track today, spent: 60, task: '3'
      end
    }

    it '#spent must return sum(:spent)' do
      _(sheet.spent).must_equal 240
    end

    it '#reward must return sum(:reward)' do
      _(sheet.reward).must_equal 240 / 60 * sheet.hourly_rate
    end
  end

end
