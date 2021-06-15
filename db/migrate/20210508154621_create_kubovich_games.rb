class CreateKubovichGames < ActiveRecord::Migration[6.0]
  def change
    create_table :kubovich_games do |t|
      t.belongs_to :chat

      t.timestamps
    end
  end
end
