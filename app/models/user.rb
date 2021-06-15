# == Schema Information
#
# Table name: users
#
#  id          :bigint           not null, primary key
#  banned      :boolean          default(FALSE)
#  first_name  :string
#  last_name   :string
#  username    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  chat_id     :bigint
#  telegram_id :bigint
#
# Indexes
#
#  index_users_on_chat_id  (chat_id)
#
class User < ApplicationRecord
  belongs_to :chat

  has_and_belongs_to_many :kubovich_games, :class_name => 'Kubovich::Game'
end
