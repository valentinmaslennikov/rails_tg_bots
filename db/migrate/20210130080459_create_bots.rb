class CreateBots < ActiveRecord::Migration[6.0]
  def change
    create_table :bots do |t|
      t.string :name
      t.boolean :enabled
      t.belongs_to :chat

      t.timestamps
    end
  end
end
