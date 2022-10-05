class Api::V1::EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: %i[show update destroy]

  def index
    @events = Event.all
      .with_status((params[:status]))
      .with_category((params[:category]))
      .order(created_at: :desc)
  end

  def show; end

  def create
    @event = current_user.events.build(event_params)

    if @event.save
      render :show, status: :created, location: @api_v1_event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def user_events
    @events = Event.where(user_id: params[:id])
    render :index, status: :ok
  end

  def update
    if @event.update(event_params)
      render :show, status: :ok, location: @api_v1_event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :status, :category, :start_date, :end_date, :user_id)
  end
end
