class AddPositionToKubovichStep < ActiveRecord::Migration[6.0]
  def change
    add_column :kubovich_steps, :position, :integer
  end
end
