class CreateSteps < ActiveRecord::Migration[6.0]
  def change
    create_table :kubovich_steps do |t|
      t.belongs_to :game
      t.belongs_to :user

      t.timestamps
    end
  end
end
