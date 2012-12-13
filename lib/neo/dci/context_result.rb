require 'on'

module Neo
  module DCI
    # Result emitted by the Context.
    class ContextResult < On
      def called?
        !!callback
      end
    end
  end
end
