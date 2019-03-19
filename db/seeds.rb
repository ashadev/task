# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



# Todo data seeding

puts "Hi.., Please wait! we are seeding your todo data..."
Todo.create(
				title: "Todo1", description: "Todo Desc1", due_date: Date.today,
				status: Todo::STATUS["Created"], kind: Todo::KIND["Development"]
			)

Todo.create(
				title: "Todo2", description: "Todo Desc2", due_date: Date.today,
				status: Todo::STATUS["Inprogress"], kind: Todo::KIND["Development"]
			)

Todo.create(
				title: "Todo3", description: "Todo Desc3", due_date: Date.today + 1.day,
				status: Todo::STATUS["Started"], kind: Todo::KIND["Designing"]
			)

Todo.create(
				title: "Todo4", description: "Todo Desc4", due_date: Date.today + 1.day,
				status: Todo::STATUS["Completed"], kind: Todo::KIND["Testing"]
			)

Todo.create(
				title: "Todo5", description: "Todo Desc5", due_date: Date.yesterday,
				status: Todo::STATUS["Inprogress"], kind: Todo::KIND["Deployment"]
			)

Todo.create(
				title: "Todo6", description: "Todo Desc6", due_date: Date.today + 3.days,
				status: Todo::STATUS["Completed"], kind: Todo::KIND["Deployment"]
			)


puts "Thanks... we finished its:-)"