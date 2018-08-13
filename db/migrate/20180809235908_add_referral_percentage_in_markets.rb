class AddReferralPercentageInMarkets < ActiveRecord::Migration
  def change
    add_column :markets, :referral_percentage, :decimal, null: false, default: 0, precision: 32, scale: 16
  end
end
