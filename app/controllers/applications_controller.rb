class ApplicationsController < ApplicationController
  before_action :set_application, only: %i[ show update destroy ]

  # GET /applications
  # GET /applications.json
  def index
    @applications = Application
    @applications = @applications.for_active_jobs unless params[:all]
    @applications = @applications.with_last_event
        .with_job
        .with_notes
        .with_interviews
  end

  # GET /applications/1
  # GET /applications/1.json
  def show
  end

  # POST /applications
  # POST /applications.json
  def create
    @application = Application.new(application_params)

    if @application.save
      render :show, status: :created, location: @application
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /applications/1
  # PATCH/PUT /applications/1.json
  def update
    if @application.update(application_params)
      render :show, status: :ok, location: @application
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  # DELETE /applications/1
  # DELETE /applications/1.json
  def destroy
    @application.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Application.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def application_params
      params.require(:application).permit(:candidate_name, :job_id)
    end
end
