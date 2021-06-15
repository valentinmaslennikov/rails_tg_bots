# == Schema Information
#
# Table name: text_directories
#
#  id         :bigint           not null, primary key
#  name       :string
#  text       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class TextDirectory < ApplicationRecord
end
