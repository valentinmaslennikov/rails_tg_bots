class AddAasmStateToKubovichStep < ActiveRecord::Migration[6.0]
  def change
    add_column :kubovich_steps, :aasm_state, :integer
  end
end
