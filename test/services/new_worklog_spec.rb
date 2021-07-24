require_relative '../test_helper'
include Worklog::Services

describe NewWorklog do

  describe '#call' do
    it 'must create timelog file' do
      Sandbox.() do
        logname = File.basename(Dir.pwd)
        filename = logname + LOGMASK[1..-1]
        result = NewWorklog.(logname)
        _(result).must_equal filename
        _(File.exist? filename).must_equal true
      end
    end

    it 'must cancel if file already exists' do
      Sandbox.() do
        logname = File.basename(Dir.pwd)
        filename = logname + LOGMASK[1..-1]
        File.write(filename, "something")
        result = ""
        _(-> {result = NewWorklog.(logname)}).must_output(/Operation canceled/)
        _(result).must_equal ''
      end

    end
  end


end
