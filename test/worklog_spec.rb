require_relative 'test_helper'

describe 'exe/worklog' do
  describe '--version' do
    it 'must print worklog version' do
      Sandbox.() do
        result, *_ = OStreamCatcher.catch { `worklog --version` }
        _(result.strip).must_equal "Worklog v#{Worklog::VERSION}"
      end
    end
  end
end
