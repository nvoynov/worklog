require_relative '../test_helper'
require 'date'
include Worklog

describe Decorator do

  describe '#tracks' do
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

    let(:decor) { Decorator.new(sheet)}

    it 'must return all tracks' do
      tracks = decor.tracks()
      _(tracks.keys).must_include :title
      _(tracks.keys).must_include :items
      _(tracks.keys).must_include :spent
      _(tracks.keys).must_include :total
      _(tracks[:title]).must_equal 'Spec'
      _(tracks[:spent]).must_equal 36 * 60
      _(tracks[:total]).must_equal 36 * 20
      %w(date spent reward task).map(&:to_sym).each {|m|
        _(tracks[:items].first).must_respond_to m
      }
    end

    describe '#this_month' do
      it 'must return this month tracks' do
        tracks = decor.this_month
        _(tracks[:items].size).must_equal 1
        _(tracks[:spent]).must_equal 14 * 60
        _(tracks[:total]).must_equal 14 * 20
      end
    end

    describe '#prev_month' do
      it 'must return this month tracks' do
        tracks = decor.prev_month
        _(tracks[:items].size).must_equal 1
        _(tracks[:spent]).must_equal 12 * 60
        _(tracks[:total]).must_equal 12 * 20
      end
    end
  end

  describe 'weeks' do
    let(:sheet) {
      today = Date.today
      this_date = today - (today.wday - 1) % 7 # this monday
      prev_date = this_date - 7          # prev monday
      arch_date = prev_date - 7          # before prev monday

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

    let(:decor) { Decorator.new(sheet)}

    describe '#this_week' do
      it 'it must return tracks of this week only' do
        tracks = decor.this_week
        _(tracks[:items].size).must_equal 1
        _(tracks[:spent]).must_equal 14 * 60
        _(tracks[:total]).must_equal 14 * 20
      end
    end

    describe '#prev_week' do
      it 'must return this month tracks' do
        tracks = decor.prev_week
        _(tracks[:items].size).must_equal 1
        _(tracks[:spent]).must_equal 12 * 60
        _(tracks[:total]).must_equal 12 * 20
      end
    end
  end

end
