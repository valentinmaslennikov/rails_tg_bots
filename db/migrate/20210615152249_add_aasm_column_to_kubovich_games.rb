class AddAasmColumnToKubovichGames < ActiveRecord::Migration[6.0]
  def change
    add_column :kubovich_games, :aasm_state, :integer
  end
end
