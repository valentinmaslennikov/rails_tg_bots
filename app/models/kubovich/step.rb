# == Schema Information
#
# Table name: kubovich_steps
#
#  id           :bigint           not null, primary key
#  aasm_state   :integer
#  answer_value :string
#  position     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  game_id      :bigint
#  user_id      :bigint
#
# Indexes
#
#  index_kubovich_steps_on_game_id  (game_id)
#  index_kubovich_steps_on_user_id  (user_id)
#
class Kubovich::Step < ApplicationRecord
  include AASM

  acts_as_list scope: :game

  self.table_name = 'kubovich_steps'

  belongs_to :user
  belongs_to :game

  enum aasm_state: %w[draft play hold].freeze, _prefix: true

  aasm do
    state :draft, initial: true
    state :play, before_enter: :set_other_to_hold
    state :hold

    event :play do
      transitions from: [:draft, :hold, :play], to: :play
    end

    event :hold do
      transitions from: [:draft, :play, :hold], to: :hold
    end
  end

  def set_other_to_hold
    game.steps.map{|i| i.hold!}
  end
end
