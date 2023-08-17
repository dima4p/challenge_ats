json.extract! job, :id, :title, :description, :status, :created_at, :updated_at
json.hired_count job.hired_count
json.rejected_count job.rejected_count
json.ongoing_count job.ongoing_count
json.url job_url(job, format: 'json')
