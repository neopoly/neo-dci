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

  test "ensure callback called" do
    context = Class.new(TestContext) do
      callbacks :success

      def call
      end
    end

    e = assert_raises Neo::DCI::Context::NoCallbackCalled do
      context.call do |callback|
      end
    end
    assert_equal "No callback called. Available callbacks: success", e.message
  end

  test "do not overwrite callbacks in subclasses" do
    context1 = Class.new(TestContext) { callbacks :foo }
    context2 = Class.new(TestContext) { callbacks :bar }

    assert_equal [ :foo ], context1.callbacks
    assert_equal [ :bar ], context2.callbacks
  end

  test "define own context result class" do
    context_result = Class.new do
      attr_reader :init_args, :init_block, :call_args

      def initialize(*args, &block)
        @init_args = args
        @init_block = block
      end

      def call(*args)
        @call_args = args
        @init_block.call self
      end

      def called?
        @call_args
      end
    end

    context = Class.new(TestContext) do
      callbacks :success
      result_class context_result

      def call
        callback.call :some, :args
      end
    end

    called = nil
    context.call do |my_result|
      called = true
      assert_equal [:success], my_result.init_args
      assert my_result.init_block
      assert_equal [:some, :args], my_result.call_args
    end

    assert called
  end
end
