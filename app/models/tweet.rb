# == Schema Information
#
# Table name: tweets
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tweet_id   :bigint
#
class Tweet < ApplicationRecord
  HIDEO_TIMELINE_ID = 117652722
end
