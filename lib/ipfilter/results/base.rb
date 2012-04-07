module Ipfilter
  module Result
    class Base
      attr_accessor :data

      def initialize(data)
        @data = data
      end

      def [](attribute)
        @data[attribute]
      end

      def to_hash
        @data
      end

      def country_code
        raise NotImplementedError.new
      end

      def country_code2
        raise NotImplementedError.new
      end

      def country_code3
        raise NotImplementedError.new
      end

      def country_name
        raise NotImplementedError.new
      end

      def continent_code
        raise NotImplementedError.new
      end
    end
  end
end
