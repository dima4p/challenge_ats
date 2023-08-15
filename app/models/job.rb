# == Schema Information
#
# Table name: jobs
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# Model Job keeps the Jobs to be applied to
#
class Job < ApplicationRecord

  validates :title, :description, presence: true

  has_many :events, class_name: '::Event', inverse_of: :object, as: :object

  scope :ordered, -> { order(:title) }

end
