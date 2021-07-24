# frozen_string_literal: true

require "test_helper"

class WorklogTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Worklog::VERSION
  end
end
