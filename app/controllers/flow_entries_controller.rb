class FlowEntriesController < ApplicationController
	before_action :set_private_mode, :set_user, :set_flow_entries
	layout "no_container"

	def index
		set_errors
	end

	private

	def set_private_mode
		@private_mode = (params[:private_mode] && params[:private_mode] == "true") ? true : false
	end

	def set_user
		@user = User.find_by(private_id: params[:id])
	end

	def set_flow_entries
		@flow_entries = FlowEntry.where(user: @user)&.order(created_at: :desc)
		@flow_entries_by_day = FlowEntry.where(user: @user)&.order(created_at: :desc).group_by{ |t| t.created_at.to_date }
	end

	def set_errors
		if @user.nil?
			flash[:error] = "Utilisateur non trouvé. As tu utilisé le bon lien ?"
		elsif @flow_entries&.count == 0
			flash[:info] = "Tu as bien lancé le test, maintenant surveille simplement les messages d'Alfred"
		elsif @flow_entries_by_day.count < 2 && @flow_entries&.count < 10
			flash[:info] = "Tu auras acces a la liste apres 10 réponses sur minimum 2 jours (progression : #{(@flow_entries.count / 10.0 * 100).to_i}%)"
		end
	end

end
