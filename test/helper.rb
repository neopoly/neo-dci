require 'simplecov' if ENV['COVERAGE']

require 'minitest/autorun'
require 'simple_assertions'

require 'neo/dci'

class NeoDCICase < MiniTest::Spec
  include SimpleAssertions::AssertRaises

  class << self
    alias :context :describe
    alias :test :it
  end
end
