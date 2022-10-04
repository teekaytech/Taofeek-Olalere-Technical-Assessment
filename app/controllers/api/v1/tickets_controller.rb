class Api::V1::TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ticket, only: %i[ show ]

  def show
  end

  def create
    puts current_user.tickets
    @ticket = current_user.tickets.build(ticket_params)

    if @ticket.save
      render :show, status: :created, location: @api_v1_ticket
    else
      render json: @ticket.errors, status: :unprocessable_entity
    end
  end

  private
    def set_ticket
      @ticket = Ticket.includes(:user, :event).find(params[:id])
    end

    def ticket_params
      params.require(:ticket).permit(:user_id, :event_id)
    end
end
