# == Schema Information
#
# Table name: tea_reviews
#
#  id         :bigint           not null, primary key
#  name       :string
#  review     :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class TeaReview < ApplicationRecord
end
