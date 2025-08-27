class CreateDeals < ActiveRecord::Migration[6.1]
  def change
    create_table :deals do |t|
      t.references :user, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :stage, default: 'prospecting'
      t.datetime :closed_at
      t.timestamps
    end

    add_index :deals, :stage
    add_index :deals, :amount
  end
end
