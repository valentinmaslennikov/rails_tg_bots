# == Schema Information
#
# Table name: chats
#
#  id         :bigint           not null, primary key
#  purge_mod  :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  system_id  :bigint
#
class Chat < ApplicationRecord
  has_many :users
  has_many :bots

  has_many :kubovich_games, :class_name => 'Kubovich::Game'
end
