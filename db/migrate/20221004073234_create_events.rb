class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.integer :status, default: 0 # 0: active, 1: inactive
      t.integer :category, default: 0 # 0: free, 1: paid

      t.timestamps
    end
  end
end
