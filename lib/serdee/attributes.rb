# frozen_string_literal: true
require "active_support/core_ext/hash"

module Serdee
  module Attributes
    def self.included(base)
      base.extend ClassMethods
    end

    attr_accessor :deserialized_from

    def initialize(**values)
      self.class.attributes.each do |key, attribute|
        if !attribute.optional && !values.key?(key)
          raise ArgumentError, "#{key} is required parameter"
        end

        if values.key?(key)
          send("#{key}=", values[key])
        elsif attribute.default
          send("#{key}=", attribute.default)
        end
      end
    end

    def attributes
      self.class.attributes.keys.each_with_object({}) do |key, hash|
        value = send(key)
        hash[key] = value if value
      end
    end

    def as_json
      self.class.insert_to(self, {}).deep_transform_keys! do |key|
        if self.class.serialize_key
          self.class.serialize_key.call(key.to_s)
        else
          key.to_s
        end
      end
    end

    def to_json
      as_json.to_json
    end

    module ClassMethods
      def attributes
        @attributes ||= {}
      end

      def serializers
        @serializers ||= {}
      end

      def serialize_key(method = nil, &block)
        if method
          @serialize_key = ->(key) { self.send(method, key) }
        elsif block
          @serialize_key = block
        else
          @serialize_key || Serdee.serialize_key
        end
      end

      def deserialize_key(method = nil, &block)
        if method
          @deserialize_key = ->(key) { self.send(method, key) }
        elsif block
          @deserialize_key = block
        else
          @deserialize_key || Serdee.deserialize_key
        end
      end

      def key_transform
        @key_transform || Serdee.default_key_transform
      end

      def attributes_class
        self
      end

      def attribute(key, *args, &block)
        attributes_class.attributes[key] = serializers[key] =
          Attribute.new(key, *args, &block)

        attributes_class.send(:attr_accessor, key)
      end

      def nested(key, nested_class = nil, &block)
        serializers[key] = Nested.new(
          attributes_class,
          key,
          nested_class&.serializers,
          &block
        )

        return unless nested_class

        attributes_class.attributes.merge!(nested_class.attributes)
        attributes_class.send(:attr_accessor, *nested_class.attributes.keys)
      end

      def from_json(json)
        of_json(JSON.parse(json))
      end

      def of_json(json)
        allocate.tap do |obj|
          data = json.deep_transform_keys do |key|
            if deserialize_key
              deserialize_key.call(key).to_sym
            else
              key.to_sym
            end
          end
          extract_to(data, obj)
          obj.deserialized_from = json
        end
      end

      def extract_to(data, obj)
        return if obj.nil?
        serializers.each do |_key, attribute|
          attribute.extract_to(data, obj)
        end
        obj
      end

      def insert_to(obj, data)
        serializers.each do |_key, attribute|
          attribute.insert_to(obj, data)
        end
        data
      end
    end

    class Nested
      include Attributes::ClassMethods

      attr_reader :key, :attributes_class
      def initialize(attributes_class, key, serializers, &block)
        @attributes_class = attributes_class
        @key = key
        @serializers = serializers
        instance_eval(&block) if block_given?
      end

      def extract_to(data, obj)
        return if data.nil? || data[key].nil?
        super(data[key], obj)
      end

      def insert_to(obj, data)
        data[key] = {}
        super(obj, data[key])
      end
    end
  end
end
