class MakeRichByDefault < ActiveRecord::Migration
  def change
    change_column_default :accounts, :balance, 300
  end
end
