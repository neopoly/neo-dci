require 'ostruct'

module Neo
  module DCI
    class ContextResult
      attr_reader :error, :data

      def success!(data = {})
        self.data = data
      end

      def failure!(error, data = {})
        @error = error
        self.data  = data
      end

      def data= (data)
        raise ArgumentError, "Data is already set. Call success! or failure! only once." if @data
        @data = Data.new(data)
        @data.freeze
      end
      private :data=

      def success?
        processed? && !error
      end

      def failure?
        processed? && !!error
      end

      def processed?
        !!@data
      end

      class Data < OpenStruct
        def to_hash
          @table
        end
      end
    end
  end
end
