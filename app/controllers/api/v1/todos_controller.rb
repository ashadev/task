class Api::V1::TodosController < ApplicationController
	before_action :set_todo, only: [:show, :update, :destroy]
	
	def index
		@todos = Todo.all.order('id DESC')
		@todos = @todos.due_date_filter(params[:date]) if params[:date].present?
		@todos = @todos.status_or_kind_filter(params[:status]) if params[:status].present?
		@todos = @todos.status_or_kind_filter(params[:kind]) if params[:kind].present?

		respond_to do |format|
          format.json
        end
	end

	def create
		data = {
					title: params[:title], 
					description: [:description], 
					due_date: params[:due_date],
					kind: params[:kind].to_s.capitalize,
					status: params[:status].to_s.capitalize
				}
		TodoWorker.perform_async(:create, data)
		
		respond_to do |format|
          format.json { render json: {status: :success, flag: true, message: 'We are processing your data'} }
        end
	end

	def show
	end

	def update
		data = {
					todo_id: @todo.id,
					title: params[:title], 
					description: [:description], 
					due_date: params[:due_date],
					kind: params[:kind].to_s.capitalize,
					status: params[:status].to_s.capitalize
				}
		TodoWorker.perform_async(:update, data)
		respond_to do |format|
          format.json { render json: {status: :success, flag: true, message: 'We are processing your data'} }
        end
	end

	def destroy
		TodoWorker.perform_async(:delete, {todo_id: @todo.id})
		respond_to do |format|
          format.json { render json: {status: :success, flag: true, error: 'We are processing your data'} }
        end
	end

	private
	def set_todo
		@todo = Todo.find_by(id: params[:id])
		render json: {status: :invalid, flag: false, error: 'This is not valid todo.'} unless @todo.present?
	end
end