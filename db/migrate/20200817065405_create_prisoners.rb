class CreatePrisoners < ActiveRecord::Migration[6.0]
  def change
    create_table :prisoners do |t|
      t.integer :term
      t.string :username

      t.timestamps
    end
  end
end
