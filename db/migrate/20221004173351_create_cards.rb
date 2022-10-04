class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.string :name
      t.text :description
      t.text :template
      t.string :visibility, default: 'private'
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :cards, :name, unique: true
  end
end
