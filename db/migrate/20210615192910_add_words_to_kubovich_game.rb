class AddWordsToKubovichGame < ActiveRecord::Migration[6.0]
  def change
    add_column :kubovich_games, :words, :string
  end
end
