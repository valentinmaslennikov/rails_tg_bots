class CreateOffences < ActiveRecord::Migration[6.0]
  def change
    create_table :offences do |t|
      t.text :text
      t.string :username

      t.timestamps
    end
  end
end
