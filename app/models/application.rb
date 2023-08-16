# == Schema Information
#
# Table name: applications
#
#  id             :integer          not null, primary key
#  candidate_name :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  job_id         :integer          not null
#
# Indexes
#
#  index_applications_on_job_id  (job_id)
#

# Model Application keeps the application made by usere
#
class Application < ApplicationRecord

  validates :candidate_name, presence: true

  belongs_to :job
  has_many :events, -> {order created_at: :asc},
      class_name: '::Event', inverse_of: :object, as: :object

  scope :ordered, -> { order(:candidate_name) }
  scope :with_job, -> {includes :job}
  scope :with_last_event, -> do
    joins(<<-SQL.strip_heredoc
      LEFT OUTER JOIN events e
      ON e.object_type = 'Application'
        AND e.object_id = applications.id
        AND e.id =
          (SELECT max(id) from events v
            WHERE v.object_type = 'Application'
              AND v.object_id = applications.id
              AND v.type != 'Application::Event::Note')
      SQL
    ).select <<-SQL.strip_heredoc
        applications.*, e.type as event_type
      SQL
  end
end
