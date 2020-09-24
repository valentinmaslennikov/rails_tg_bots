class AddPurgemodToChat < ActiveRecord::Migration[6.0]
  def change
    add_column :chats, :purge_mod, :boolean
  end
end
