# == Schema Information
#
# Table name: kubovich_tasks
#
#  id         :bigint           not null, primary key
#  answer     :string
#  task       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Kubovich::Task < ApplicationRecord
  self.table_name = 'kubovich_tasks'

  has_many :game_tasks, class_name: 'Kubovich::GameTask'
  has_many :games, through: :game_tasks, class_name: 'Kubovich::Game'
end
