class ProfilesController < ApplicationController
  # Callbacks: Executa o método set_profile antes destas ações específicas para não repetirmos código
  before_action :set_profile, only: %i[ show edit update destroy ]

  # Rota: GET /profiles
  def index
    # AUTORIZAÇÃO (Pundit): O usuário logado tem permissão para listar perfis?
    authorize Profile 
    @profiles = Profile.all
  end

  # Rota: GET /profiles/1
  def show
    # AUTORIZAÇÃO (Pundit): O usuário logado pode ver ESTE perfil específico?
    authorize @profile
  end

  # Rota: GET /profiles/new
  def new
    @profile = Profile.new
    # AUTORIZAÇÃO (Pundit): O usuário logado pode acessar a tela de criação?
    authorize @profile
  end

  # Rota: GET /profiles/1/edit
  def edit
    # AUTORIZAÇÃO (Pundit): O usuário logado pode acessar a tela de edição DESTE perfil?
    authorize @profile
  end

  # Rota: POST /profiles
  def create
    @profile = Profile.new(profile_params)
    
    # AUTORIZAÇÃO (Pundit): O usuário logado pode salvar um novo perfil no banco?
    authorize @profile

    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: "Perfil criado com sucesso." }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @profile.errors, status: :unprocessable_content }
      end
    end
  end

  # Rota: PATCH/PUT /profiles/1
  def update
    # AUTORIZAÇÃO (Pundit): O usuário logado tem permissão para alterar ESTE perfil?
    authorize @profile

    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to @profile, notice: "Perfil atualizado com sucesso.", status: :see_other }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @profile.errors, status: :unprocessable_content }
      end
    end
  end

  # Rota: DELETE /profiles/1
  def destroy
    # AUTORIZAÇÃO (Pundit): O usuário logado tem permissão de exclusão para ESTE perfil?
    authorize @profile
    
    @profile.destroy!

    respond_to do |format|
      format.html { redirect_to profiles_path, notice: "Perfil excluído com sucesso.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

    # Método utilitário: Busca o perfil no banco de dados com base no ID da URL
    def set_profile
      @profile = Profile.find(params.expect(:id))
    end

    # Segurança (Strong Parameters): Filtra apenas os campos confiáveis enviados pelo formulário
    # Evita que um hacker injete dados indevidos (ex: forçar a mudança de um user_id que não lhe pertence)
    def profile_params
      params.expect(profile: [ :user_id, :first_name, :last_name, :avatar_url, :phone, :bio ])
    end
end