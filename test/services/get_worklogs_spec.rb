require_relative '../test_helper'
include Worklog::Services

describe GetWorklogs do

  let(:log) {
    <<~EOF
      title "first"
      hourly_rate 20

      track '2020-07-21', spent: '8h', task: 'working on vision document'
      track '2020-07-22', spent: '2h', task: 'working on vision document'
      track '2020-07-23', spent: '8h', task: 'working on user stories'
      track '2020-07-24', spent: '4h', task: 'working on user stories'
      track '2020-07-25', spent: '8h', task: 'working on use cases'
      track '2020-07-26', spent: '6h', task: 'working on use cases'
    EOF
  }

  it 'must load timelogs from the working directory' do
    Sandbox.() do
      File.write("log1#{Worklog::LOGMASK[1..-1]}", log)
      File.write("log3#{Worklog::LOGMASK[1..-1]}", log)
      File.write("log2#{Worklog::LOGMASK[1..-1]}",
        log.gsub('title "first"', 'title "second"'))

      OStreamCatcher.catch do  
        GetWorklogs.().tap do |sheets|
          _(sheets.size).must_equal 2
          _(sheets.first.title).must_equal 'first'
          _(sheets.last.title).must_equal 'second'
        end
      end
    end
  end
end
