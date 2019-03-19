json.status :success
json.flag true
json.todos @todos do |todo|
	json.id todo.id
	json.title todo.title
	json.description todo.description
	json.status todo.status
	json.kind todo.kind
	json.due_date todo.pretty_due_date
	json.created_at pretty_created_at(todo)
	json.updated_at pretty_modified_at(todo)
end