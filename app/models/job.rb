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

  has_many :applications
  has_many :applications_with_state, -> {with_last_event_type}, class_name: 'Application'
  has_many :events, -> {order id: :asc},
      class_name: '::Event', inverse_of: :object, as: :object

  scope :ordered, -> { order(:title) }
  scope :activated, -> do
    joins(<<-SQL.strip_heredoc
        INNER JOIN events e
        ON e.object_type = 'Job'
          AND e.object_id = jobs.id
          AND e.id = (SELECT max(id) from events v
        WHERE v.object_type = 'Job'
          AND v.object_id = jobs.id)
          AND e.type = 'Job::Event::Activated'
      SQL
      )
  end
  scope :with_applications, -> {includes :applications_with_state}
  scope :with_last_event, -> do
    joins(<<-SQL.strip_heredoc
      LEFT OUTER JOIN events e
      ON e.object_type = 'Job'
        AND e.object_id = jobs.id
        AND e.id =
          (SELECT max(id) from events v
            WHERE v.object_type = 'Job' AND v.object_id = jobs.id)
      SQL
    )
  end
  scope :with_last_event_type, -> do
    with_last_event.select <<-SQL.strip_heredoc
        jobs.*, e.type as event_type, (e.type = 'Job::Event::Activated') as activated
      SQL
  end

  def hired_count
    applications.hired.count(:all)
  end

  def ongoing_count
    applications.count - hired_count - rejected_count
  end

  def rejected_count
    applications.rejected.count(:all)
  end

  def status
    return @status if @status
    @status = if respond_to?(:event_type)
          event_type
        else
          events.last&.type
        end
    @status ||= 'deactivated'
    @status = @status.split('::').last.downcase
  end
end
