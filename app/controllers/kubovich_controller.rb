class KubovichController < Telegram::Bot::UpdatesController
  before_action :set_chat_id, :set_current_user

  def start!(*args)
    @game = @chat.kubovich_games.create!(task: Kubovich::Task.find(Kubovich::Task.pluck(:id).sample))
    args.each do |i|
      user = User.find_or_create_by!(username: i)
      @game.users << user
      @game.steps.create!(user: user)
    end

    @game.start!

    current_game.steps.first.play!

    respond_with :message, text: "Мы начинаем, вот задание на 1й тур \n #{current_task.task} \n #{current_step.user.username} вращайте барабан/буква/слово целиком"
  rescue => e
    respond_with :message, text: e
  end

  def task!(*args)
    respond_with :message, text: current_task.task
  end

  def bukva!(*args)
    if current_step.user.username.eql? @user.username
      result = if current_step.answer_value.nil?
                 current_task.answer.downcase.split('').reduce('') { |acc, i| i.eql?(args[0].downcase.strip) ? acc + i : acc + '_' }
               else
                 current_step.answer_value.split('').reduce('') { |acc, i| i.eql?(args[0].downcase.strip) ? acc + i : acc + '_' }
               end

      if current_game.steps.where('position > ?', current_step.position).first.present?
        current_game.steps.where('position > ?', current_step.position).first.play!
      else
        current_game.steps.first.play!
      end

      respond_with :message, text: "#{result}\n#{@game.users.sample.username} вращайте барабан/буква/слово целиком"
    else
      respond_with :message, text: 'не выкрикивайте с места, дождитесь очереди!'
    end
  end

  def slovo!(*args)
    if current_task.answer.downcase.eql?(args[0].downcase.strip)
      respond_with :message, text: "И у нас победитель!"
    else
      respond_with :message, text: "К сожалению вы нас покидаете"
    end
  end

  def help!(*args)
    respond_with :message, text: "тут будет хелп"
  end

  def drop_current_game!(*args)
    @chat.kubovich_games.find_by(aasm_state: :play).finish!
    respond_with :message, text: 'ko'
  end

  private

  def set_chat_id
    @chat ||= Chat.find_or_create_by(system_id: chat['id'])
  end

  def set_current_user
    @user = User.find_or_create_by(telegram_id: from['id']) do |user|
      user.first_name = from['first_name']
      user.last_name = from['last_name']
      user.username = from['username']
      user.chat = @chat
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
end