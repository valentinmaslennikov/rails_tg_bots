class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :username
      t.bigint :telegram_id
      t.string :first_name
      t.string :last_name
      t.boolean :banned, default: false
      t.belongs_to :chat

      t.timestamps
    end
  end
end
