# == Schema Information
#
# Table name: prisoners
#
#  id         :bigint           not null, primary key
#  term       :integer
#  username   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Prisoner < ApplicationRecord
end
