module Neo
  module DCI
    class Context

      class << self
        private :new
      end

      def self.call(*args, &block)
        context = new(*args, &block)
        result  = ContextResult.new
        context.call(result)
        raise UnprocessedError unless result.processed?
        result
      rescue NotImplementedError
        raise
      end


      def call(result)
        raise NotImplementedError
      end

      class UnprocessedError < StandardError; end
    end
  end
end
