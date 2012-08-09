require 'simplecov' if ENV['COVERAGE']

require 'minitest/autorun'

require 'neo/dci'

class NeoDCICase < MiniTest::Spec
  class << self
    alias :context :describe
    alias :test :it
  end
end
