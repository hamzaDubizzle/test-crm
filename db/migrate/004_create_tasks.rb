class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :customer, null: true, foreign_key: true
      t.references :deal, null: true, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.date :due_date, null: false
      t.string :priority, default: 'medium'
      t.string :status, default: 'pending'
      t.timestamps
    end

    add_index :tasks, :due_date
    add_index :tasks, :priority
    add_index :tasks, :status
  end
end
