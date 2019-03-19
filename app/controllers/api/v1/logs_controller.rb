class Api::V1::LogsController < ApplicationController
	before_action :set_log, only: [:show]

	def index
		@logs = Log.all.order('id DESC')
	end


	def show
	end

	private
	def set_log
		@log = Log.find_by(id: params[:id])
		render json: {status: :invalid, flag: false, error: 'This is not valid log.'} unless @log.present?
	end
end