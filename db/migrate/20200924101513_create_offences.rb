class CreateOffences < ActiveRecord::Migration[6.0]
  def change
    create_table :offences do |t|
      t.text :text
      t.integer :username, limit: 8

      t.timestamps
    end
  end
end
