module Neo
  module DCI
    class Context
      class << self
        private :new

        def callbacks(*args)
          @callbacks ||= []
          @callbacks = args unless args.empty?
          @callbacks
        end

        def call(*args, **kwargs, &block)
          context = new(*args, **kwargs)
          context.callback = result_class.new(*callbacks, &block)
          context.call
          raise NoCallbackCalled, callbacks unless context.callback.called?
        rescue NotImplementedError
          raise
        end

        def result_class(klass = :reader)
          @result_class = klass unless klass == :reader
          defined?(@result_class) ? @result_class : ContextResult
        end
      end

      attr_accessor :callback

      def call
        raise NotImplementedError
      end

      class NoCallbackCalled < StandardError
        def initialize(callbacks)
          super("No callback called. Available callbacks: #{callbacks.join(", ")}")
        end
      end
    end
  end
end
