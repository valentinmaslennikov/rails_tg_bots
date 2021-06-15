# == Schema Information
#
# Table name: bots
#
#  id         :bigint           not null, primary key
#  enabled    :boolean
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  chat_id    :bigint
#
# Indexes
#
#  index_bots_on_chat_id  (chat_id)
#
class Bot < ApplicationRecord
  belongs_to :chat
end
