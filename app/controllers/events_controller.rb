class EventsController < ApplicationController
  before_action :set_event, only: %i[ show update destroy ]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    if @event.save
      render :show, status: :created, location: event_path(@event)
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    if @event.update(event_params)
      render :show, status: :ok, location: event_path(@event)
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
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
      type = params['event']['type'] || @event.type
      list = %i[
        type
        object_type
        object_id
      ]
      list << :date if %w[Application::Event::Interview
                          Application::Event::Hired].include? type
      list << :content if type == 'Application::Event::Note'

      params.require(:event).permit list
    end
end
