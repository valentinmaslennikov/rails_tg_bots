class KubovichController < Telegram::Bot::UpdatesController
  include ErrorHandleable

  before_action :set_chat_id, :set_current_user
  before_action :check_player, except: [:message, :drop_current_game!, :task!, :start!, :help!]
  before_action :is_active_player?, only: [:bukva!, :slovo!]
  before_action :is_current_game?, only: [:bukva!, :slovo!, :task!, :drop_current_game!]

  def message(*args) end

  def start!(*args)
    ActiveRecord::Base.transaction do
      @game = @chat.kubovich_games.create!(task: Kubovich::Task.find(Kubovich::Task.pluck(:id).sample))
      raise Errors::NotEnoughPlayers if args.length < 2
      args.each do |i|
        user = User.find_by!(username: i, chat: @chat)
        @game.users << user
        @game.steps.create!(user: user)
      end
      @game.start!
      @game.steps.first.play!

      respond_with :message, text: "Мы начинаем, вот задание на 1й тур\n#{@game.task.task}\n#{@game.steps.first.user.username.prepend('@')} вращайте барабан/буква/слово целиком"
    end
  rescue => e
    respond_with :message, text: e
  end

  def task!(*args)
    respond_with :message, text: current_task.task
  end

  def bukva!(*args)
    result = if current_task.answer.downcase.include?(args.first.to_s.downcase.strip)
               current_game.update!(words: current_game.words + args.first.to_s.downcase.strip)
               words = current_game.reload.words.split('')
               if current_game.steps.where('position > ?', current_step.position).first.present?
                 current_game.steps.where('position > ?', current_step.position).first.play!
               else
                 current_game.steps.first.play!
               end
               current_task.answer.downcase.split('').reduce('') { |acc, i| ([i] & words).present? ? acc + i : acc + '_ ' }
             else
               'к сожалению такой буквы тут нет'
             end
    current_step.update!(answer_value: result)
    respond_with :message, text: "#{result}\n#{current_game.current_step.user.username.prepend('@')} вращайте барабан/буква/слово целиком"
  end

  def slovo!(*args)
    if current_task.answer.downcase.eql?(args[0].downcase.strip)
      respond_with :message, text: "И у нас победитель!"
      current_game.finish!
    else
      respond_with :message, text: "К сожалению вы нас покидаете"
      if current_game.steps.where('position > ?', current_step.position).first.present?
        current_game.steps.where('position > ?', current_step.position).first.play!
      else
        current_game.steps.first.play!
      end
      current_game.users.delete(@user)
      current_step.destroy
    end
  rescue => e
    respond_with :message, text: e
  end

  def help!(*args)
    respond_with :message, text: "начинаем игру командой '/start@kubovich_bot username1 username2 username3' etc, если ваша очередь хода то пишем '/bukva@kubovich_bot м' или '/slovo@kubovich_bot ответ' "
  end

  def drop_current_game!(*args)
    current_game.finish!
    respond_with :message, text: 'ko'
  end

  private

  def set_chat_id
    @chat ||= Chat.find_or_create_by(system_id: chat['id'])
  rescue => e
    respond_with :message, text: e
  end

  def is_active_player?
    raise Errors::WrongPlayer unless current_step.user.username.eql? @user.username
  end

  def is_current_game?
    raise Errors::NoGameInProgressError if current_game.nil?
  end

  def set_current_user
    @user = User.find_or_create_by(telegram_id: from['id']) do |user|
      user.first_name = from['first_name']
      user.last_name  = from['last_name']
      user.username   = from['username']
      user.chat       = @chat
    end
  end

  def current_game
    @current_game ||= @chat.kubovich_games.find_by(aasm_state: :play)
  end

  def current_step
    @current_step ||= current_game.current_step
  end

  def current_task
    @current_task ||= current_game.task
  end

  def check_player
    if current_game.present? && !current_game.users.include?(@user)
      raise Errors::OtherUser
    end
  end
end
