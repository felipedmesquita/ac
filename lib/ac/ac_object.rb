module Ac
  class AcObject
    attr_reader :response

    def self.from_response(response)
      parsed_json = JSON.parse(response.body) rescue {}
      new(parsed_json, response: response)
    end

    def initialize(parsed_json, response: nil)
      @response = response
      @values = parsed_json.transform_keys(&:to_s)
      @values.keys.each do |key|
        define_singleton_method(key) { self.[](key) } unless respond_to? key
      end
    end

    def [](key)
      wrap(@values[key.to_s])
    end

    def to_s(*_args)
      JSON.pretty_generate(@values)
    end

    def inspect
      id_string = respond_to?(:id) && !id.nil? ? " id=#{id}" : ''
      "#<#{self.class}:0x#{object_id.to_s(16)}#{id_string}> JSON: " +
        JSON.pretty_generate(@values)
    end

    def ==(other)
      other.is_a? AcObject
      @values == other.instance_variable_get('@values')
    end

    def eql?(other)
      self == other
    end

    def keys
      @values.keys
    end

    def values
      @values.values
    end

    def json
      @values
    end

    private

    def wrap(value)
      case value
      when Hash
        AcObject.new(value)
      when Array
        value.map { wrap(_1) }
      else
        value
      end
    end
  end
end
