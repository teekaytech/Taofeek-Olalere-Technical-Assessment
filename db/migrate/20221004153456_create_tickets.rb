class CreateTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :tickets, id: :uuid do |t|
      t.integer :status, default: 0 # 0: active, 1: inactive
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :event, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
    add_index :tickets, %i[ user_id event_id ], unique: true
  end
end
