# frozen_string_literal: true
module Serdee
  class Attribute
    attr_reader :key, :default
    attr_writer :as
    attr_accessor :default, :allow_blank, :serializer, :optional

    def initialize(key, **options, &block)
      @key = key
      { allow_blank: false }.merge(options).each do |option, setting|
        config.public_send(option, setting)
      end
      config.instance_eval(&block) if block_given?
    end

    def config
      @config ||= Config.new(self)
    end

    def as
      @as || key
    end

    def default=(val)
      @optional = true
      @default = val
    end

    def insert(value, hash)
      new_value = serialize(value)
      hash[as] = new_value if new_value.present? || allow_blank
    end

    def insert_to(obj, hash)
      insert(obj.send(key), hash)
      hash
    end

    def extract_to(data, obj)
      obj.send("#{key}=", extract(data))
      obj
    end

    def extract(hash)
      deserialize(hash[as])
    end

    def serialize(value)
      value
    end

    def deserialize(value)
      value
    end

    class Config
      attr_reader :attribute
      def initialize(attribute)
        @attribute = attribute
      end

      def serializer(obj)
        return unless obj

        attribute.serializer = obj
        serialize { |value| obj.serialize(value) }
        deserialize { |value| obj.deserialize(value) }
      end

      [
        :optional,
        :default,
        :allow_blank,
        :as
      ].each do |key|
        define_method(key) do |value|
          attribute.send("#{key}=", value)
        end
      end

      [
        :extract_to,
        :insert_to,
        :extract,
        :insert,
        :serialize,
        :deserialize
      ].each do |key|
        expected_arg_size = Attribute.instance_method(key).parameters.size
        define_method(key) do |&block|
          if block.parameters.size > expected_arg_size || block.parameters.any? { |type, _key| type == :keyreq }
            raise ArgumentError,
              "wrong number of arguments defined for ##{key} (given #{block.parameters}, expected #{args})"
          end
          attribute.singleton_class.send(:define_method, key, &block)
        end
      end
    end
  end
end
