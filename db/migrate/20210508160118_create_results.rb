class CreateResults < ActiveRecord::Migration[6.0]
  def change
    create_table :kubovich_results do |t|
      t.belongs_to :game

      t.timestamps
    end
  end
end
