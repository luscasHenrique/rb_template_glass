class TrackingIntegrationsController < ApplicationController
  before_action :set_tracking_integration, only: %i[ edit update destroy ]

  # GET /admin/integrations
  def index
    # AUTORIZAÇÃO: O Pundit verifica a TrackingIntegrationPolicy#index?
    authorize TrackingIntegration
    @tracking_integrations = TrackingIntegration.all
  end

  # GET /admin/integrations/1
#   def show
#     authorize @tracking_integration
#   end

  # GET /admin/integrations/new
  def new
    @tracking_integration = TrackingIntegration.new
    authorize @tracking_integration
  end

  # GET /admin/integrations/1/edit
  def edit
    authorize @tracking_integration
  end

  # POST /admin/integrations
  def create
    @tracking_integration = TrackingIntegration.new(tracking_integration_params)
    authorize @tracking_integration

    respond_to do |format|
      if @tracking_integration.save
        format.html { redirect_to tracking_integrations_path, notice: "Integração de rastreio criada com sucesso." }
        format.json { render :show, status: :created, location: @tracking_integration }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @tracking_integration.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /admin/integrations/1
  def update
    authorize @tracking_integration

    respond_to do |format|
      if @tracking_integration.update(tracking_integration_params)
        format.html { redirect_to tracking_integrations_path, notice: "Integração de rastreio atualizada com sucesso.", status: :see_other }
        format.json { render :show, status: :ok, location: @tracking_integration }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @tracking_integration.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /admin/integrations/1
  def destroy
    authorize @tracking_integration
    @tracking_integration.destroy!

    respond_to do |format|
      format.html { redirect_to tracking_integrations_path, notice: "Integração de rastreio removida com sucesso.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tracking_integration
      @tracking_integration = TrackingIntegration.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through (Strong Parameters).
    def tracking_integration_params
      params.expect(tracking_integration: [ :provider_name, :account_id, :is_active ])
    end
end