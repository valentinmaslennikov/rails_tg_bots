class KubovichController < Telegram::Bot::UpdatesController
  before_action :set_chat_id, :set_current_user, :check_player

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
  rescue => e
    respond_with :message, text: e
  end

  def bukva!(*args)
    if current_step.user.username.eql? @user.username
      result = if current_step.answer_value.nil?
                 current_task.answer.downcase.split('').reduce('') { |acc, i| i.eql?(args[0].downcase.strip) ? acc + i : acc + '_ ' }
               else
                 current_step.answer_value.split('').reduce('') { |acc, i| i.eql?(args[0].downcase.strip) ? acc + i : acc + '_ ' }
               end

      current_step.update!(answer_value: result)

      if current_game.steps.where('position > ?', current_step.position).first.present?
        current_game.steps.where('position > ?', current_step.position).first.play!
      else
        current_game.steps.first.play!
      end

      respond_with :message, text: "#{result}\n#{current_game.current_step.user.username} вращайте барабан/буква/слово целиком"
    else
      respond_with :message, text: 'не выкрикивайте с места, дождитесь очереди!'
    end
  rescue => e
    respond_with :message, text: e
  end

  def slovo!(*args)
    if current_step.user.username.eql? @user.username
      if current_task.answer.downcase.eql?(args[0].downcase.strip)
        respond_with :message, text: "И у нас победитель!"
        current_game.finish!
      else
        respond_with :message, text: "К сожалению вы нас покидаете"
        current_game.users.delete(@user)
      end
    else
      respond_with :message, text: 'не выкрикивайте с места, дождитесь очереди!'
    end
  rescue => e
    respond_with :message, text: e
  end

  def help!(*args)
    respond_with :message, text: "начинаем игру командой '/start username1 username2 username3' etc\n
                                        если ваша очередь хода '/bukva м' или '/slovo ответ' "
  rescue => e
    respond_with :message, text: e
  end

  def drop_current_game!(*args)
    @chat.kubovich_games.find_by(aasm_state: :play).finish!
    respond_with :message, text: 'ko'
  rescue => e
    respond_with :message, text: e
  end

  private

  def set_chat_id
    @chat ||= Chat.find_or_create_by(system_id: chat['id'])
  rescue => e
    respond_with :message, text: e
  end

  def set_current_user
    @user = User.find_or_create_by(telegram_id: from['id']) do |user|
      user.first_name = from['first_name']
      user.last_name  = from['last_name']
      user.username   = from['username']
      user.chat       = @chat
    end
  rescue => e
    respond_with :message, text: e
  end

  def current_game
    @current_game ||= @chat.kubovich_games.find_by(aasm_state: :play)
  rescue => e
    respond_with :message, text: e
  end

  def current_step
    @current_step ||= current_game.current_step
  rescue => e
    respond_with :message, text: e
  end

  def current_task
    @current_task ||= current_game.task
  rescue => e
    respond_with :message, text: e
  end

  def check_player
    if current_game.present? && !current_game.users.include?(@user)
      respond_with :message, text: 'что за крики из зала? выведите его в коридор, и расстреляйте его там нахуй!'
    end
  rescue => e
    respond_with :message, text: e
  end
end