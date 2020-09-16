class ChangeIntToTweetId < ActiveRecord::Migration[6.0]
  def change
    change_column :tweets, :tweet_id, :integer, limit: 8
  end
end
