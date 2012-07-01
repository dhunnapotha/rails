require "cases/helper"

module ActiveRecord
  class Migration
    class << self
      attr_accessor :message_count
    end

    def puts(text="")
      ActiveRecord::Migration.message_count ||= 0
      ActiveRecord::Migration.message_count += 1
    end

    module TestHelper
      attr_reader :connection, :table_name

      CONNECTION_METHODS = %w[add_column remove_column rename_column add_index change_column rename_table]

      class TestModel < ActiveRecord::Base
        self.table_name = :test_models
      end

      def setup
        super
        @connection = ActiveRecord::Base.connection
        connection.create_table :test_models do |t|
          t.timestamps
        end

        TestModel.reset_column_information
      end

      def teardown
        super
        TestModel.reset_table_name
        TestModel.reset_sequence_name
        connection.drop_table :test_models rescue nil
      end

      private

      delegate(*CONNECTION_METHODS, to: :connection)
    end
  end
end
