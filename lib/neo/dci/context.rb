require 'on'

module Neo
  module DCI
    class Context
      class << self
        private :new
      end

      attr_accessor :callback

      def self.callbacks(*args)
        @callbacks ||= []
        @callbacks = args unless args.empty?
        @callbacks
      end

      def self.call(*args, &block)
        context = new(*args)
        context.callback = On.new(*callbacks, &block)
        context.call
        raise NoCallbackCalled, callbacks unless context.callback.callback
      rescue NotImplementedError
        raise
      end

      def call
        raise NotImplementedError
      end

      class NoCallbackCalled < StandardError
        def initialize(callbacks)
          super("No callback called. Available callbacks: #{callbacks.join(', ')}")
        end
      end
    end
  end
end
