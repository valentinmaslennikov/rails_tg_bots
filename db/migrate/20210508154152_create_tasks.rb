class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :kubovich_tasks do |t|
      t.text :task
      t.string :answer

      t.timestamps
    end
  end
end
