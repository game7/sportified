class FixTypoInVoucherComsumedAt < ActiveRecord::Migration[5.2]
  def change
    rename_column :vouchers, :comsumed_at, :consumed_at
  end
end
