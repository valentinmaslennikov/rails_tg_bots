class RemoveEnabledField < ActiveRecord::Migration[6.0]
  def change
    remove_column :chats, :enabled, :boolean
  end
end
