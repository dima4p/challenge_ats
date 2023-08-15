# == Schema Information
#
# Table name: applications
#
#  id             :integer          not null, primary key
#  candidate_name :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

# Model Application keeps the application made by usere
#
class Application < ApplicationRecord

  validates :candidate_name, presence: true

  scope :ordered, -> { order(:candidate_name) }

end
