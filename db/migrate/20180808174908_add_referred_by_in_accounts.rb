class AddReferredByInAccounts < ActiveRecord::Migration
  def change
    add_column :members, :referred_by_id, :integer
    add_index :members, :referred_by_id
  end
end
