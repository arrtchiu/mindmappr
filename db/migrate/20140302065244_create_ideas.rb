class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.references :parent, index: true
      t.string :content, null: false

      t.timestamps
    end
  end
end
