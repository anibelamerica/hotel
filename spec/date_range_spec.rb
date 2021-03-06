require_relative 'spec_helper'

describe 'DateRange class' do
  let (:today) { Date.today }
  let (:week_later) { today + 7}
  let (:before_today) {today - 2}
  let (:range) { Hotel::DateRange.new(today, week_later) }

  let (:same_dates) { Hotel::DateRange.new(today, week_later) }
  let (:overlap_front) { Hotel::DateRange.new(before_today, today + 1) }
  let (:overlap_back) { Hotel::DateRange.new(today + 1, week_later + 1) }
  let (:contained) { Hotel::DateRange.new(today + 1, week_later - 1) }
  let (:containing) { Hotel::DateRange.new(before_today, week_later + 1) }

  let (:before_dates) { Hotel::DateRange.new(before_today - 1, before_today) }
  let (:after_dates) { Hotel::DateRange.new(week_later + 1, week_later + 2) }
  let (:ends_on_checkin) { Hotel::DateRange.new(before_today, today) }
  let (:starts_on_checkout) { Hotel::DateRange.new(week_later, week_later + 1) }

  describe 'DateRange instantiation' do

    it 'creates an instance of DateRange' do
      expect(Hotel::DateRange.new(today, week_later)).must_be_instance_of Hotel::DateRange

      expect(Hotel::DateRange.new(today, week_later)).must_respond_to :check_in

      expect(Hotel::DateRange.new(today, week_later)).must_respond_to :check_out
    end

    it 'raises an Argument error if end date is before the start date' do
      expect{
        Hotel::DateRange.new(today, before_today)
      }.must_raise ArgumentError
    end

    it 'raises an Argument error if given anything besides a Date object' do
      expect{
        Hotel::DateRange.new("2000-10-10", before_today)
      }.must_raise ArgumentError

      expect{
        Hotel::DateRange.new(today, 20001010)
      }.must_raise ArgumentError
    end
  end

  describe 'get_total_days method' do
    it 'returns the number of days in the date range' do
      expect(range.get_total_days).must_equal 7
    end
  end

  describe 'is_within_date_range' do
    it 'returns true if date is within the range' do
      expect(range.is_within_date_range(today)).must_equal true
    end

    it 'returns false if date is outside the range' do
      expect(range.is_within_date_range(before_today)).must_equal false
    end

    it 'returns false if given an invalid date' do
      expect(range.is_within_date_range('Not a Date')).must_equal false
    end
  end

  describe 'overlaps? method' do

    it 'returns true if the given date range is the same' do
      expect(range.overlaps?(same_dates)).must_equal true
    end

    it 'returns true if the given date range overlaps in the front' do
      expect(range.overlaps?(overlap_front)).must_equal true
    end

    it 'returns true if the given date range overlaps in the back' do
      expect(range.overlaps?(overlap_back)).must_equal true
    end

    it 'returns true if the given date range is completely contained' do
      expect(range.overlaps?(contained)).must_equal true
    end

    it 'returns true if the given date range completely contains the other date range' do
      expect(range.overlaps?(containing)).must_equal true
    end

    it 'returns false if the given date range occurs before' do
      expect(range.overlaps?before_dates).must_equal false
    end

    it 'returns false if the given date range occurs after' do
      expect(range.overlaps?after_dates).must_equal false
    end

    it 'returns false if the given date range ends on other\'s check_in' do
      expect(range.overlaps?ends_on_checkin).must_equal false
    end

    it 'returns false if the given date range starts on other\'s check_out' do
      expect(range.overlaps?starts_on_checkout).must_equal false
    end
  end
end
