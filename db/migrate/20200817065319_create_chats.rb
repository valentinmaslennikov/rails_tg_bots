class CreateChats < ActiveRecord::Migration[6.0]
  def change
    create_table :chats do |t|
      t.integer :system_id
      t.boolean :enabled

      t.timestamps
    end
  end
end
