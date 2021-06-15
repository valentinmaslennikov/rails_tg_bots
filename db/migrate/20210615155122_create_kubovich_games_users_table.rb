class CreateKubovichGamesUsersTable < ActiveRecord::Migration[6.0]
  def change
    create_table :kubovich_games_users do |t|
      t.belongs_to :game
      t.belongs_to :user
    end
  end
end
