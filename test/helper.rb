require 'simplecov' if ENV['COVERAGE']

require 'minitest/autorun'
require 'testem'

require 'neo/dci'

class NeoDCICase < Testem
end
