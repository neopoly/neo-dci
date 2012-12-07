require 'helper'

class ContextTest < NeoDCICase
  class TestContext < Neo::DCI::Context
    def initialize(*args)
      @args = args
    end
  end

  test "initialize is private" do
    assert_raises NoMethodError do
      TestContext.new
    end
  end

  test "raises not implement error" do
    assert_raises NotImplementedError do
      Class.new(Neo::DCI::Context) do
        callbacks :foo
      end.call {}
    end
  end

  test "yields callback" do
    context = Class.new(TestContext) do
      callbacks :success

      def call
        callback.call :success, @args
      end
    end

    block_called = false
    result = nil

    context.call(:foo, :bar) do |callback|
      block_called = true
      callback.on :success do |args|
        result = args
      end
    end

    assert_equal true, block_called
    assert_equal [ :foo, :bar ], result
  end

  test "allow that no callback called" do
    block_called = false
    context = Class.new(TestContext) do
      callbacks :success

      def call
      end
    end

    context.call do |callback|
      block_called = true
    end

    refute block_called
  end

  test "do not overwrite callbacks in subclasses" do
    context1 = Class.new(TestContext) { callbacks :foo }
    context2 = Class.new(TestContext) { callbacks :bar }

    assert_equal [ :foo ], context1.callbacks
    assert_equal [ :bar ], context2.callbacks
  end
end
