require_relative '../test_helper'
include Worklog::Services

describe 'Some new load service' do

  let(:today)

  let(:logA1) {
    Worklog::Worklog.DSL.build do
      title  "Alpha"
      author "John"
      track today.to_s, spent: "8h", task: "Alpha John"
    end
  }

  let(:logB1) {
    Worklog::Worklog.DSL.build do
      title  "Beta"
      author "John"
      track today.to_s, spent: "8h", task: "Beta John"
    end
  }

  let(:logA2) {
    Worklog::Worklog.DSL.build do
      title  "Alpha"
      author "Jane"
      track today.to_s, spent: "8h", task: "Alpha Jane"
    end
  }

  let(:logB2) {
    Worklog::Worklog.DSL.build do
      title  "Beta"
      author "Jane"
      track today.to_s, spent: "8h", task: "Beta Jane"
    end
  }

  describe '#call' do
    # after loading there must be four separate worklogs
    #   Alpha John, Alpha Jane, Beta John, Beta Jane
    # and print must print each worklog separatedly
    #
    # what command should be for pivot table? pivot!
    # and what pivot shoul do? prepare source and
    #   provide ability to group and calculate subtotals
  end

end
