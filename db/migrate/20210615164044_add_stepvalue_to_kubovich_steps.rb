class AddStepvalueToKubovichSteps < ActiveRecord::Migration[6.0]
  def change
    add_column :kubovich_steps, :answer_value, :string
  end
end
