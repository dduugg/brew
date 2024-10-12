# typed: strict
# frozen_string_literal: true

require_relative "../../../global"
require "requirement"
require "software_spec"
require "formula"
require "cleanup"
require "debrew"
require "system_command"
require "cask"

module Tapioca
  module Compilers
    # A compiler for subclasses of Delegator.
    # To add a new delegator: require it above add add it to the DELEGATIONS hash below.
    class Forwardables < Tapioca::Dsl::Compiler
      ARRAY_METHODS = T.let(["to_a", "to_ary"].freeze, T::Array[String])
      HASH_METHODS = T.let(["to_h", "to_hash"].freeze, T::Array[String])
      STRING_METHODS = T.let(["to_s", "to_str", "to_json"].freeze, T::Array[String])

      ConstantType = type_member { { fixed: Module } }

      sig { override.returns(T::Enumerable[Module]) }
      def self.gather_constants
        ObjectSpace.each_object(Forwardable).to_set
      end

      sig { override.void }
      def decorate
        root.create_path(constant) do |klass|
          imeths = constant.instance_methods(false)
                          .map { |method_name| [constant.instance_method(method_name), false] }
          cmeths = constant.methods(false)
                          .map { |method_name| [constant.method(method_name), true] }
          attrs = (imeths + cmeths).select { |method, _| method.source_location&.first&.end_with?('forwardable.rb') }
          attrs.each do |method, class_method|
            name = method.name.to_s

            return_type = return_type(name)
            klass.create_method(
              name,
              parameters: [
                create_rest_param("args", type: "T.untyped"),
                # create_kw_rest_param("opts", type: "T.untyped"),
                create_block_param("block", type: "T.untyped"),
              ],
              return_type:,
              class_method:
            )
          end
        end
      end

      private

      sig { params(name: String).returns(String) }
      def return_type(name)
        if name.end_with?("?")
          "T::Boolean"
        elsif ARRAY_METHODS.include?(name)
          "Array"
        elsif HASH_METHODS.include?(name)
          "Hash"
        elsif STRING_METHODS.include?(name)
          "String"
        else
          "T.untyped"
        end
      end
    end
  end
end
