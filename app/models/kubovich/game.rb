# == Schema Information
#
# Table name: kubovich_games
#
#  id         :bigint           not null, primary key
#  aasm_state :integer
#  words      :string           default("")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  chat_id    :bigint
#
# Indexes
#
#  index_kubovich_games_on_chat_id  (chat_id)
#
class Kubovich::Game < ApplicationRecord
  include AASM

  self.table_name = 'kubovich_games'

  has_and_belongs_to_many :users

  has_one :game_task, class_name: 'Kubovich::GameTask'
  has_one :task, through: :game_task, class_name: 'Kubovich::Task'
  belongs_to :chat

  has_many :steps, -> { order(position: :asc) }, class_name: 'Kubovich::Step'

  has_one :result, class_name: 'Kubovich::Result'

  enum aasm_state: %w[draft play finished].freeze, _prefix: true

  aasm do
    state :draft, initial: true
    state :play
    state :finished

    event :start do
      transitions from: :draft, to: :play, guard: :no_other_games?
    end

    event :finish do
      transitions from: :play, to: :finished
    end
  end

  def no_other_games?
    chat.kubovich_games.where(aasm_state: :finished)
  end

  def current_step
    steps.find_by(aasm_state: :play)
  end
end
