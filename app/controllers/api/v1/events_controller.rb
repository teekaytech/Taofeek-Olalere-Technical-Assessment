class Api::V1::EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: %i[ show update destroy ]

  # GET /api/v1/events.json
  def index
    @events = Event.all
  end

  # GET /api/v1/events/:id.json
  def show
  end

  # POST /api/v1/events.json
  def create
    @event = current_user.events.build(event_params)

    if @event.save
      render :show, status: :created, location: @api_v1_event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  # GET /api/v1/users/:id/events.json
  def user_events
    @events = Event.where(user_id: params[:id])
    render :index, status: :ok
  end

  # PATCH/PUT /api/v1/events/:id.json
  def update
    if @event.update(event_params)
      render :show, status: :ok, location:  @api_v1_event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/events/:id.json
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
