# == Schema Information
#
# Table name: kubovich_results
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint
#
# Indexes
#
#  index_kubovich_results_on_game_id  (game_id)
#
class Kubovich::Result < ApplicationRecord
  self.table_name = 'kubovich_results'

  belongs_to :game, :class_name => 'Kubovich::Game'

  has_many :users
end
