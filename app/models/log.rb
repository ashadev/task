class Log < ApplicationRecord
	enum operation: [:created, :updated, :deleted]
	enum status: [:started, :completed, :failed, :deployment] 
    OPERATION = {
    			"Created" => :created, "Updated" => :updated, "Deleted" => :deleted
    		}
    STATUS = {
    			"Started" => :started, "Completed" => :completed, "Failed" => :failed
    		}
end
