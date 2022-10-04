class Api::V1::EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: %i[ show update destroy ]

  # GET /api/v1/events
  # GET /api/v1/events.json
  def index
    @events = Event.all
  end

  # GET /api/v1/events/1
  # GET /api/v1/events/1.json
  def show
  end

  # POST /api/v1/events
  # POST /api/v1/events.json
  def create
    @event = Event.new(event_params)

    if @event.save
      render :show, status: :created, location: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/events/1
  # PATCH/PUT /api/v1/events/1.json
  def update
    if @event.update(event_params)
      render :show, status: :ok, location: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/events/1
  # DELETE /api/v1/events/1.json
  def destroy
    @event.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:title, :description, :status, :category, :start_date, :end_date)
    end
end
