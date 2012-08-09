require 'helper'

class ContextTest < NeoDCICase
  class DummyContext < Neo::DCI::Context
    def initialize(&block)
      @block = block
    end

    def call(result)
      @block.call(result)
    end
  end

  let(:data)  { {:foo => :bar }  }
  let(:error) { RuntimeError.new }

  test "initialize is private" do
    assert_raises NoMethodError do
      DummyContext.new
    end
  end

  test "raises not implement error" do
    assert_raises NotImplementedError do
      Class.new(Neo::DCI::Context).call
    end
  end

  test "raises unprocessed error if result is not processed" do
    assert_raises Neo::DCI::Context::UnprocessedError do
      Class.new(Neo::DCI::Context) do
        def call(result); end
      end.call
    end
  end

  test "returns context result if success" do
    result = DummyContext.call do |result|
      result.success!(data)
    end
    assert result.success?
    refute result.failure?
    assert_equal :bar, result.data.foo
  end

  test "returns context result if failure" do
    result = DummyContext.call do |result|
      result.failure!(error, data)
    end
    assert result.failure?
    refute result.success?
    assert_same  error, result.error
    assert_equal :bar, result.data.foo
  end

end
