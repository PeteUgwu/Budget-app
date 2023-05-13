class CreateJoinTableTransactionCategory < ActiveRecord::Migration[7.0]
  def change
    create_join_table :transacts, :categories do |t|
      t.index [:transact_id, :category_id]
      t.index [:category_id, :transact_id]
    end
  end
end
