Rails.application.routes.draw do
  #telegram_webhook TelegramSunshineController, :sunshine
  #telegram_webhook TelegramTeaController, :tea_bot
  telegram_webhook TelegramRustController, :upgrade
  telegram_webhook TelegramHideoController, :hideo_bot
  telegram_webhook KubovichController, :kubovich_bot
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#root'

  resources :tea_reviews
  resources :offences
end
