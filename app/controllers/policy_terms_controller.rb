class PolicyTermsController < ApplicationController
  before_action :set_policy_term, only: %i[ show edit update destroy ]

  # GET /policy_terms
  def index
    authorize PolicyTerm # SEGURANÇA: Checa a Policy antes de listar
    @policy_terms = PolicyTerm.all
  end

  # GET /policy_terms/1
  def show
    authorize @policy_term # SEGURANÇA: Checa se pode ver este registro
  end

  # GET /policy_terms/new
  def new
    authorize PolicyTerm # SEGURANÇA: Checa se tem permissão de abrir o formulário
    @policy_term = PolicyTerm.new
  end

  # GET /policy_terms/1/edit
  def edit
    authorize @policy_term # SEGURANÇA: Checa se tem permissão para editar
  end

  # POST /policy_terms
  def create
    authorize PolicyTerm # SEGURANÇA: Checa permissão antes de salvar
    @policy_term = PolicyTerm.new(policy_term_params)

    if @policy_term.save
      redirect_to @policy_term, notice: "O novo Termo foi criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /policy_terms/1
  def update
    authorize @policy_term # SEGURANÇA: Checa permissão antes de atualizar
    if @policy_term.update(policy_term_params)
      redirect_to @policy_term, notice: "O Termo foi atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /policy_terms/1
  def destroy
    authorize @policy_term # SEGURANÇA: Checa permissão antes de deletar
    @policy_term.destroy!

    redirect_to policy_terms_url, notice: "O Termo foi removido com sucesso."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_policy_term
      @policy_term = PolicyTerm.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def policy_term_params
      params.require(:policy_term).permit(:version, :content, :active)
    end
end