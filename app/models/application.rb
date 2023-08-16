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

  belongs_to :job
  has_many :events, -> {order created_at: :asc},
      class_name: '::Event', inverse_of: :object, as: :object
  has_many :interviews, -> {where(type: 'Application::Event::Interview')
                       .order date: :asc},
      class_name: '::Event', inverse_of: :object, as: :object
  has_many :notes, -> {where(type: 'Application::Event::Note')
                       .order created_at: :asc},
      class_name: '::Event', inverse_of: :object, as: :object

  validates :candidate_name, presence: true

  scope :aplied, -> {with_last_event.where e: {type: nil}}
  scope :for_active_jobs, -> do
    joins(<<-SQL.strip_heredoc
        INNER JOIN events e
        ON e.object_type = 'Job'
          AND e.object_id = job_id
          AND e.id = (SELECT max(id) from events v
        WHERE v.object_type = 'Job'
          AND v.object_id = job_id)
          AND e.type = 'Job::Event::Activated'
      SQL
    )
  end
  scope :interview, -> do
    with_last_event.where e: {type: 'Application::Event::Interview'}
  end
  scope :hired, -> do
    with_last_event.where e: {type: 'Application::Event::Hired'}
  end
  scope :rejected, -> do
    with_last_event.where e: {type: 'Application::Event::Rejected'}
  end
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
    ).select 'applications.*, e.type as event_type'
  end

  def status
    return @status if @status
    @status = if respond_to?(:event_type)
          event_type
        else
          events.where.not(type: 'Application::Event::Note').last&.type
        end
    @status ||= 'applied'
    @status = @status.split('::').last.downcase
  end
end
