class Todo < ApplicationRecord
	validates :title, :description, :due_date, presence: true

	enum status: [:created, :started, :inprogress, :completed]
	enum kind: [:development, :designing, :testing, :deployment] 
    STATUS = {
    			"Created" => :created, "Started" => :started, 
    			"Inprogress" => :inprogress, "Completed" => :completed
    		}
    KIND = {
    			"Development" => :development, "Designing" => :designing,
    			"Testing" => :testing, "Deployment" => :deployment
    		}

    TODAY_DATE = Date.today.strftime("%d/%m/%Y")

    def self.due_date_filter(due_date = TODAY_DATE)
    	begin
	    	Todo.where('DATE(due_date) =?', Date.parse(due_date))
	    rescue
	    	return Todo.none
	    end
    end

    def self.status_or_kind_filter(todo_type)
    	begin
    		Todo.send(todo_type)
    	rescue
    		return Todo.none
    	end
    end

    def pretty_due_date
    	return '' unless due_date.present?

		due_date.strftime("%d/%m/%Y")
    end
end
