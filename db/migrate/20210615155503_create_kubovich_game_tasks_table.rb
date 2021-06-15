class CreateKubovichGameTasksTable < ActiveRecord::Migration[6.0]
  def change
    create_table :kubovich_game_tasks do |t|
      t.belongs_to :game
      t.belongs_to :task
    end
  end
end
