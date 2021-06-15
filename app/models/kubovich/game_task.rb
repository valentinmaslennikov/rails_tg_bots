# == Schema Information
#
# Table name: kubovich_game_tasks
#
#  id      :bigint           not null, primary key
#  game_id :bigint
#  task_id :bigint
#
# Indexes
#
#  index_kubovich_game_tasks_on_game_id  (game_id)
#  index_kubovich_game_tasks_on_task_id  (task_id)
#
class Kubovich::GameTask < ApplicationRecord
  self.table_name = 'kubovich_game_tasks'

  belongs_to :game, class_name: 'Kubovich::Game'
  belongs_to :task, class_name: 'Kubovich::Task'
end
