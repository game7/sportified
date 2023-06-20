module Registration::Summarization
  extend ActiveSupport::Concern

  module ClassMethods
    def summarize
      ByProduct.call
    end
  end

  class ByProduct < Projection
    attribute :product_id, :integer
    attribute :total_count, :integer
    attribute :pending_count, :integer
    attribute :cancelled_count, :integer
    attribute :abandoned_count, :integer
    attribute :completed_count, :integer
    attribute :completed_value, :float

    def self.call
      query = Product.left_joins(:registrations)
                     .group(Columns.product_id)
                     .select(Columns.product_id.as('product_id'),
                             Columns.total_count,
                             Columns.pending_count,
                             Columns.cancelled_count,
                             Columns.abandoned_count,
                             Columns.completed_count,
                             Columns.completed_value)

      ActiveRecord::Base.connection.select_all(query.to_sql).to_a
    end

    class Columns
      def self.product_id
        Product.arel_table['id']
      end

      def self.total_count
        table['id'].count
      end

      def self.pending_count
        Arel::Nodes::Case.new.when(pending).then(1).else(0).sum.as('pending_count')
      end

      def self.cancelled_count
        Arel::Nodes::Case.new.when(table['cancelled_at'].not_eq(nil)).then(1).else(0).sum.as('cancelled_count')
      end

      def self.abandoned_count
        Arel::Nodes::Case.new.when(table['abandoned_at'].not_eq(nil)).then(1).else(0).sum.as('abandoned_count')
      end

      def self.completed_count
        Arel::Nodes::Case.new.when(completed).then(1).else(0).sum.as('completed_count')
      end

      def self.completed_value
        price = Arel::Nodes::NamedFunction.new(
          'coalesce',
          [table['price'], 0]
        )
        Arel::Nodes::Case.new.when(completed).then(price).else(0).sum.as('completed_value')
      end

      class << self
        private

        def table
          Registration.arel_table
        end

        def pending
          table['cancelled_at'].eq(nil)
                               .and(table['abandoned_at'].eq(nil))
                               .and(table['completed_at'].eq(nil))
        end

        def completed
          table['cancelled_at'].eq(nil)
                               .and(table['abandoned_at'].eq(nil))
                               .and(table['completed_at'].not_eq(nil))
        end
      end
    end
  end
end
