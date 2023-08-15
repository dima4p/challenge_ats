json.extract! application, :id, :candidate_name, :created_at, :updated_at
json.url application_url(application, format: 'json')
json.job_title application.job.title
