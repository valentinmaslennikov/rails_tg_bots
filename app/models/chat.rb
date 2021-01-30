class Chat < ApplicationRecord
  has_many :users
  has_many :bots
end
