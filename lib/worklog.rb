# frozen_string_literal: true

require_relative "worklog/version"
require_relative "worklog/entities"
require_relative "worklog/services"
require_relative "worklog/dsl"
require_relative "worklog/cli"
require_relative "worklog/decorator"
require_relative "worklog/printer"
require "yaml"

module Worklog
  class Error < StandardError; end

  # FILE_MASK = "*.timelog".freeze
  LOGMASK = "*.worklog".freeze
  GEMHOME = ".worklog".freeze
  STORAGE = "index.yml".freeze

  def params
    @params ||= read_params
  end

  def indexd
    return if Dir.glob(LOGMASK).empty?
    return if params[:index].include? Dir.pwd

    params[:index] << Dir.pwd
    home = File.join(Dir.home, GEMHOME)
    Dir.mkdir(home) unless Dir.exist?(home)
    File.write(
      File.join(home, STORAGE),
      YAML.dump(params)
    )
  end

  protected

  def read_params
    para = {}

    home = File.join(Dir.home, GEMHOME)
    Dir.mkdir(home) unless Dir.exist?(home)

    file = File.join(home, 'index.yml')
    para = YAML.load(File.read(file)) if File.exist?(file)
    para[:index] ||= []
    para
  end

  def save_params
  end

end
