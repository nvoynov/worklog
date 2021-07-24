# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "worklog"

require "minitest/autorun"

class Sandbox
  def self.call
    Dir.mktmpdir(['worklog']) {|dir|
      Dir.chdir(dir) { yield }
    }
  end
end

module OStreamCatcher

  def catch(&block)
    stdout_orig, stdout_mock = mock_stdout
    stderr_orig, stderr_mock = mock_stderr

    stderr_orig = $stderr
    stderr_mock = StringIO.new
    $stderr = stderr_mock

    begin
      result = block.call
    ensure
      $stdout = stdout_orig
      $stderr = stderr_orig
    end

    [result, stdout_mock.string, stderr_mock.string]
  end

    protected

      def mock_stdout
        orig = $stdout
        mock = StringIO.new
        $stdout = mock
        [orig, mock]
      end

      def mock_stderr
        orig = $stderr
        mock = StringIO.new
        $sterr = mock
        [orig, mock]
      end

  extend self

end


SPECTIMELOG = 'spec.timelog'

SPECCONTENT = <<~EOF
  title "Worklog"
  date_format "%Y-%m-%d"
  hourly_rate 20

  track '2021-06-10', spent: '8h', task: 'work on func requirements'
  track '2021-06-11', spent: '8h', task: 'work on func requirements'
  track '2021-06-12', spent: '8h30m', task: 'work on use cases'
  track '2021-07-10', spent: '8h', task: 'work on func requirements'
  track '2021-07-11', spent: '8h', task: 'work on func requirements'
  track '2021-07-12', spent: '8h30m', task: 'work on use cases'
  track '2021-07-13', spent: '30m', task: 'work on user stories'
  track '2021-07-14', spent: '2h30m', task: 'work on user stories', rate: 30
EOF

def write_spec_log
  File.write(SPECTIMELOG, SPECCONTENT)
end
