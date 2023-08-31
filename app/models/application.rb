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

  scope :aplied, -> do
    select('applications.*')
        .from(with_last_event.where(e2: {type: nil}), :applications)
  end
  scope :for_active_jobs, -> do
    joins(<<-SQL.strip_heredoc
        INNER JOIN events e1
        ON e1.object_type = 'Job'
          AND e1.object_id = job_id
          AND e1.id = (SELECT max(id) from events v1
        WHERE v1.object_type = 'Job'
          AND v1.object_id = job_id)
          AND e1.type = 'Job::Event::Activated'
      SQL
    )
  end
  scope :interview, -> do
    select('applications.*')
        .from(with_last_event.where(e2: {type: 'Application::Event::Interview'}),
              :applications)
  end
  scope :hired, -> do
    select('applications.*')
        .from(with_last_event.where(e2: {type: 'Application::Event::Hired'}),
              :applications)
  end
  scope :rejected, -> do
    select('applications.*')
        .from(with_last_event.where(e2: {type: 'Application::Event::Rejected'}),
              :applications)
  end
  scope :ordered, -> { order(:candidate_name) }
  scope :with_interviews, -> {includes :interviews}
  scope :with_job, -> {includes :job}
  scope :with_last_event, -> do
    joins(<<-SQL.strip_heredoc
      LEFT OUTER JOIN events e2
      ON e2.object_type = 'Application'
        AND e2.object_id = applications.id
        AND e2.id =
          (SELECT max(id) from events v2
            WHERE v2.object_type = 'Application'
              AND v2.object_id = applications.id
              AND v2.type != 'Application::Event::Note')
      SQL
    )
  end
  scope :with_last_event_type, -> do
    with_last_event.select 'applications.*, e2.type as event_type'
  end
  scope :with_notes, -> {includes :notes}

  class << self
    def count(column_name = nil)
      column_name ||= :all
      super column_name
    end
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
