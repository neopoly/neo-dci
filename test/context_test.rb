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
    $success_callback_arg = nil

    listener = Class.new do
      def register_callbacks(result)
        result.on :success do |arg|
          $success_callback_arg = arg
        end
      end
    end

    context_result = Class.new(Neo::DCI::ContextResult) do
      def register(listener)
        listener.register_callbacks(self)
      end
    end

    context = Class.new(TestContext) do
      callbacks :success
      result_class context_result

      def call
        callback.call :success, :ok
      end
    end

    context.call do |my_result|
      my_result.register listener.new
    end

    assert_equal :ok, $success_callback_arg
  end

  test "pass attributes and kwargs do context" do
    context = Class.new(TestContext) do
      callbacks :success

      def initialize(attribute, kwarg:)
        @attribute = attribute
        @kwarg = kwarg
      end

      def call
        callback.call :success, @attribute, @kwarg
      end
    end

    context.call("attribute", kwarg: "kwarg") do |result|
      result.on :success do |attr, kwarg|
        assert_equal "attribute", attr
        assert_equal "kwarg", kwarg
      end
    end
  end

  test "pass only attributes do context" do
    context = Class.new(TestContext) do
      callbacks :success

      def initialize(attribute)
        @attribute = attribute
      end

      def call
        callback.call :success, @attribute
      end
    end

    context.call("attribute") do |result|
      result.on :success do |attr|
        assert_equal "attribute", attr
      end
    end
  end

  test "pass only kwargs do context" do
    context = Class.new(TestContext) do
      callbacks :success

      def initialize(kwarg:)
        @kwarg = kwarg
      end

      def call
        callback.call :success, @kwarg
      end
    end

    context.call(kwarg: "kwarg") do |result|
      result.on :success do |kwarg|
        assert_equal "kwarg", kwarg
      end
    end
  end
end
