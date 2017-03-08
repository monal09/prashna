class BotsController < ApplicationController

  def talk
  end

  def bot_response
    reaction = TIMEPASS.get_reaction(params[:query])
    render json: { response: reaction.present? ? reaction : "Sorry. Can't help on this" }
  end
end
