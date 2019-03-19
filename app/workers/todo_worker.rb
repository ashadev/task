class TodoWorker
  include Sidekiq::Worker

  def perform(operation, data = {})
  	return unless data.present?
  	send(operation, data)
  end

  def create(data = {})
  	Log.create(operation: Log::OPERATION["Created"], status: Log::STATUS["Started"])
  	todo = Todo.new(
				title: data['title'], 
				description: data['description'], 
				due_date: data['due_date'],
				kind: Todo::KIND[data['kind']],
				status: Todo::STATUS[data['status']]
			)
		if todo.save
			Log.create(
						operation: Log::OPERATION["Created"], 
						status: Log::STATUS["Completed"]
					)
		else
			Log.create(
						operation: Log::OPERATION["Created"], 
						status: Log::STATUS["Failed"],
						reason: todo.errors.messages
					)
		end
  end

  def update(data = {})
  	Log.create(operation: Log::OPERATION["Updated"], status: Log::STATUS["Started"])
  	todo_id = data['todo_id']
  	todo = Todo.find_by(id: todo_id)
  	if todo.present?
  		flag = todo.update title: data['title'], 
					description: data['description'], 
					due_date: data['due_date'],
					kind: Todo::KIND[data['kind']],
					status: Todo::STATUS[data['status']]
		if flag
			Log.create(
						operation: Log::OPERATION["Updated"], 
						status: Log::STATUS["Completed"]
					)
		else
			Log.create(
						operation: Log::OPERATION["Updated"], 
						status: Log::STATUS["Failed"],
						reason: todo.errors.messages
					)
		end
	else
		Log.create(
						operation: Log::OPERATION["Updated"], 
						status: Log::STATUS["Failed"],
						reason: 'Todo id is not valid'
					)
	end
  end

  def delete(data = {})
  	Log.create(operation: Log::OPERATION["Deleted"], status: Log::STATUS["Started"])
  	todo_id = data['todo_id']
  	todo = Todo.find_by(id: todo_id)
  	if todo.present?
  		flag = todo.destroy
  		if flag
  			Log.create(
						operation: Log::OPERATION["Deleted"], 
						status: Log::STATUS["Completed"]
					)
		else
			Log.create(
						operation: Log::OPERATION["Deleted"], 
						status: Log::STATUS["Failed"],
						reason: todo.errors.messages
					)
		end
	else
		Log.create(
						operation: Log::OPERATION["Deleted"], 
						status: Log::STATUS["Failed"],
						reason: 'Todo id is not valid'
					)
	end
  end
end
