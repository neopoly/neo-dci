require 'helper'

class ContextResultTest < NeoDCICase
  let(:result) { Neo::DCI::ContextResult.new }
  let(:error)  { RuntimeError.new  }
  let(:data)   { {:foo  => :bar}   }

  test "returns success? when no error present" do
    result.success!
    assert result.success?
    assert result.processed?
    refute result.failure?
    assert_nil result.error
  end

  test "returns failure? on error" do
    result.failure!(error)
    refute result.success?
    assert result.failure?
    assert result.processed?
    assert_same error, result.error
  end

  test "returns not processed? on default" do
    refute result.processed?
    refute result.success?
    refute result.failure?
  end

  test "returns data as payload on success" do
    result.success!(data)
    assert_equal data[:foo], result.data.foo
  end

  test "returns data as payload on failure" do
    result.failure!(error, data)
    assert_equal data[:foo], result.data.foo
  end

  context "frozen data" do
    test "after success!" do
      result.success!
      assert result.data.frozen?
    end
    test "after failure!" do
      result.failure!(error)
      assert result.data.frozen?
    end
  end

  context "can only be called once" do
    before do
      result.success!
    end

    test "with success!" do
      assert_raises ArgumentError, :message => /once/ do
        result.success!
      end
    end

    test "with failure!" do
      assert_raises ArgumentError, :message => /once/ do
        result.failure!(error)
      end
    end
  end
end
