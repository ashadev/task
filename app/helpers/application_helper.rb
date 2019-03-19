module ApplicationHelper
	def pretty_created_at(entity)
		return '' unless entity.present?
		return '' unless entity.created_at.present?

		entity.created_at.strftime("%d/%m/%Y %I:%M:%S %p")
	end

	def pretty_modified_at(entity)
		return '' unless entity.present?
		return '' unless entity.updated_at.present?

		entity.updated_at.strftime("%d/%m/%Y %I:%M:%S %p")
	end
end
