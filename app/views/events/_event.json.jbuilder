json.extract! event, :id, :type, :object_type, :object_id, :date, :content, :created_at, :updated_at
json.url event_url(event, format: 'json')
