class CreateCustomers < ActiveRecord::Migration[6.1]
  def change
    create_table :customers do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.string :company
      t.string :status, default: 'lead'
      t.text :notes
      t.timestamps
    end

    add_index :customers, :email
    add_index :customers, :status
  end
end
