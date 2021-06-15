class CreateGameTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :game_tasks do |t|

      t.timestamps
    end
  end
end
