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
require "requirement"

module Tapioca
  module Compilers
    # A compiler for subclasses of Delegator.
    # To add a new delegator: require it above add add it to the DELEGATIONS hash below.
    class Attrables < Tapioca::Dsl::Compiler
      ConstantType = type_member { { fixed: Module } }

      sig { override.returns(T::Enumerable[Module]) }
      def self.gather_constants
        ObjectSpace.each_object(Attrable).to_set
      end

      sig { override.void }
      def decorate
        root.create_path(constant) do |klass|
          imeths = constant.instance_methods
                          .map { |method_name| constant.instance_method(method_name) }
                          .select { |method| method.owner.to_s == constant.singleton_class.to_s }
                          .map { |method| [method, false] }
          cmeths = constant.methods
                          .map { |method_name| constant.method(method_name) }
                          .select { |method| method.owner.to_s == constant.singleton_class.to_s }
                          .map { |method| [method, true] }
          attrs = (imeths + cmeths).select { |method, _| method.source_location.first.end_with?('attrable.rb') }
          attrs.each do |method, class_method|
            case method.arity
            when -1
              # attr_rw
              klass.create_method(
                method.name.to_s,
                parameters: [create_opt_param("arg", type: "T.untyped", default: "nil")],
                return_type: "T.untyped",
                class_method:
              )
            when 0
              # attr_predicate
              klass.create_method(
                method.name.to_s,
                return_type: "T::Boolean",
                class_method:
              )
            else
              raise "Unsupported arity for method #{method.name} - did `Attrable` change?"
            end
          end
        end
      end
    end
  end
end
