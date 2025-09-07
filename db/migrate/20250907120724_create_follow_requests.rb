class CreateFollowRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :follow_requests do |t|
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :receiver, null: false, foreign_key: { to_table: :users }
      t.string :status

      t.timestamps
    end
  end
end
