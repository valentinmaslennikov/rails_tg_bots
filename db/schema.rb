# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_06_15_192910) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bots", force: :cascade do |t|
    t.string "name"
    t.boolean "enabled"
    t.bigint "chat_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chat_id"], name: "index_bots_on_chat_id"
  end

  create_table "chats", force: :cascade do |t|
    t.bigint "system_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "purge_mod"
  end

  create_table "game_tasks", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "kubovich_game_tasks", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "task_id"
    t.index ["game_id"], name: "index_kubovich_game_tasks_on_game_id"
    t.index ["task_id"], name: "index_kubovich_game_tasks_on_task_id"
  end

  create_table "kubovich_games", force: :cascade do |t|
    t.bigint "chat_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "aasm_state"
    t.string "words", default: ""
    t.index ["chat_id"], name: "index_kubovich_games_on_chat_id"
  end

  create_table "kubovich_games_users", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "user_id"
    t.index ["game_id"], name: "index_kubovich_games_users_on_game_id"
    t.index ["user_id"], name: "index_kubovich_games_users_on_user_id"
  end

  create_table "kubovich_results", force: :cascade do |t|
    t.bigint "game_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_kubovich_results_on_game_id"
  end

  create_table "kubovich_steps", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "position"
    t.string "answer_value"
    t.integer "aasm_state"
    t.index ["game_id"], name: "index_kubovich_steps_on_game_id"
    t.index ["user_id"], name: "index_kubovich_steps_on_user_id"
  end

  create_table "kubovich_tasks", force: :cascade do |t|
    t.text "task"
    t.string "answer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "offences", force: :cascade do |t|
    t.text "text"
    t.string "username"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "prisoners", force: :cascade do |t|
    t.integer "term"
    t.string "username"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tea_reviews", force: :cascade do |t|
    t.string "name"
    t.text "review"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "text_directories", force: :cascade do |t|
    t.string "name"
    t.text "text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tweets", force: :cascade do |t|
    t.bigint "tweet_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.bigint "telegram_id"
    t.string "first_name"
    t.string "last_name"
    t.boolean "banned", default: false
    t.bigint "chat_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chat_id"], name: "index_users_on_chat_id"
  end

end
