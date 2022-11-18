class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.integer :status, null: false, default: 0
      t.references :user, null: false, foreign_key: true
      t.references :author, null: false, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
