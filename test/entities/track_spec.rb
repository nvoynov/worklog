require_relative '../test_helper'
require 'date'
include Worklog::Entities

describe Track do
  let(:today) { Date.today }

  describe '#new' do
    it 'must create Track' do
      date = Date.today
      t = Track.new(date, spent: 10)
      _(t.spent).must_equal 10
      _(t.date).must_equal date
      _(t.task).must_equal ''
      _(t.rate).must_equal 0
    end

    it 'must prevent to point :spent more than 24h' do
      _(->{Track.new(today, spent: 1441)}).must_raise ArgumentError
    end

    it 'must prevent to point :date in future' do
      _(->{Track.new(today + 1, spent: 30)}).must_raise ArgumentError
    end

  end

  describe '#reward' do
    it 'must round to 2 digits in :half_down mode' do
      t1 = Track.new(today, spent: 999, rate: 20.193)
      _(t1.reward).must_equal 336.21 # 336,21345
      t2 = Track.new(today, spent: 999, rate: 20.983)
      _(t2.reward).must_equal 349.37 # 349,36695
    end
  end

end
