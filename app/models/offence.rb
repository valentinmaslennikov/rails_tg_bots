# == Schema Information
#
# Table name: offences
#
#  id         :bigint           not null, primary key
#  text       :text
#  username   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Offence < ApplicationRecord
end
