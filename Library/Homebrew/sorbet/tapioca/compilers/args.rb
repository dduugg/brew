# typed: strict
# frozen_string_literal: true

require_relative "../../../global"

# require all the commands
["cmd", "dev-cmd"].each do |dir|
  Dir[File.join(__dir__, "../../../#{dir}", "*.rb")].each { require(_1) }
end

module Tapioca
  module Compilers
    class Args < Tapioca::Dsl::Compiler
      # This is ugly, but we're moving to a new interface that will use a consistent DSL
      # These are cmd/dev-cmd methods that end in `_args` but do not return parsers
      NON_PARSER_ARGS_METHODS = T.let([
        :formulae_all_installs_from_args,
        :reproducible_gnutar_args,
        :tar_args,
      ].freeze, T::Array[Symbol])

      # FIXME: Enable cop again when https://github.com/sorbet/sorbet/issues/3532 is fixed.
      # rubocop:disable Style/MutableConstant
      Parsable = T.type_alias { T.any(T.class_of(Homebrew::CLI::Args), T.class_of(Homebrew::AbstractCommand)) }

      ConstantType = type_member { { fixed: Parsable } }
      # rubocop:enable Style/MutableConstant

      sig { override.returns(T::Enumerable[Parsable]) }
      def self.gather_constants = [Homebrew::CLI::Args] + Homebrew::AbstractCommand.subclasses

      sig { override.void }
      def decorate
        if constant == Homebrew::CLI::Args
          root.create_path(Homebrew::CLI::Args) do |klass|
            Homebrew.methods(false).select { _1.end_with?("_args") }.each do |args_method_name|
              next if NON_PARSER_ARGS_METHODS.include?(args_method_name)

              parser = Homebrew.method(args_method_name).call
              create_args_methods(klass, parser)
            end
          end
        else
          root.create_path(Homebrew::CLI::Args) do |klass|
            parser = Homebrew::CLI::Parser.new(&T.cast(constant, T.class_of(Homebrew::AbstractCommand)).parser_block)
            create_args_methods(klass, parser)
          end
        end
      end

      private

      sig { params(klass: RBI::Scope, parser: Homebrew::CLI::Parser).void }
      def create_args_methods(klass, parser)
        comma_array_methods = comma_arrays(parser)
        args = parser.instance_variable_get(:@args)
        args.instance_variable_get(:@table).each do |method_name, value|
          # some args are used in multiple commands (this is ok as long as they have the same type)
          next if klass.nodes.any? { T.cast(_1, RBI::Method).name == method_name } || value == []

          return_type = get_return_type(method_name, value, comma_array_methods)
          klass.create_method(method_name, return_type:)
        end
      end

      sig { params(method_name: Symbol, value: T.untyped, comma_array_methods: T::Array[Symbol]).returns(String) }
      def get_return_type(method_name, value, comma_array_methods)
        if comma_array_methods.include?(method_name)
          "T.nilable(T::Array[String])"
        elsif [true, false].include?(value)
          "T::Boolean"
        else
          "T.nilable(String)"
        end
      end

      sig { params(parser: Homebrew::CLI::Parser).returns(T::Array[Symbol]) }
      def comma_arrays(parser)
        parser.instance_variable_get(:@non_global_processed_options)
              .select { |_, v| v == :comma_array }.map { |k, _| parser.option_to_name(k).to_sym }
      end
    end
  end
end
