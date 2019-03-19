json.status :success
json.flag true
json.logs @logs do |log|
	json.id log.id
	json.reason log.reason
	json.operation log.operation
	json.status log.status
	json.created_at pretty_created_at(log)
	json.updated_at pretty_modified_at(log)
end