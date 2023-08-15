# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  type        :string           not null
#  object_type :string           not null
#  object_id   :integer          not null
#  date        :datetime
#  content     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# Model Event is the base Model from wich all types of events inherit
#
class Event < ApplicationRecord

  belongs_to :object, polymorphic: true

  validates :type, presence: true
  validates :type, inclusion: {in: %w[
        Application::Event::Hired
        Application::Event::Inerview
        Application::Event::Note
        Application::Event::Rejected
        Job::Event::Activated
        Job::Event::Deactivated
      ]}
  validates :object_type, inclusion: {in: %w[
        Application
        Job
      ]}
  validates :object, presence: true

  scope :ordered, -> { order(:type) }

end
