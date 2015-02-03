module SchemaMonkey::Core
  module ActiveRecord
    module Migration
      module CommandRecorder
        def self.included(base)
          base.class_eval do
            alias_method_chain :add_column, :schema_monkey
          end
        end

        def add_column_with_schema_monkey(table_name, column_name, type, options = {})
          SchemaMonkey::Middleware::Migration::Column.start(caller: self, operation: :record, table_name: table_name, column_name: column_name, type: type, options: options.deep_dup) do |env|
            add_column_without_schema_monkey env.table_name, env.column_name, env.type, env.options
          end
        end
      end
    end
  end
end