if ENV['CODECLIMATE_REPO_TOKEN']
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require 'simplecov' if ENV['COVERAGE']

require 'minitest/autorun'
require 'testem'

require 'neo/dci'

class NeoDCICase < Testem
end
