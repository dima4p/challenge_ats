json.extract! application, :id, :candidate_name, :status, :created_at, :updated_at
json.number_of_notes application.notes.to_a.size
json.date_of_first_interview application.interviews.first&.date || 'null'
json.url application_url(application, format: 'json')
json.job_title application.job.title
