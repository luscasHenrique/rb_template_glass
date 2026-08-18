class Admin::UsersController < ApplicationController
  # O Pundit vai garantir que apenas quem tem a role adequada acesse essas ações
  before_action :set_user, only: %i[edit update audit_logs]

  # GET /admin/users
  def index
    authorize [:admin, User] 
    # includes(:profile) evita o problema de N+1 queries no banco de dados
    @users = User.includes(:profile).order(created_at: :desc)
  end

  # GET /admin/users/:id/edit
  def edit
    authorize [:admin, @user]
  end

  # PATCH/PUT /admin/users/:id
  def update
    authorize [:admin, @user]
    
    # 1. Armazenamos os parâmetros em uma variável local (filtered_params)
    filtered_params = user_params

    # 2. Limpamos a senha APENAS desta variável se ela vier em branco
    if filtered_params[:password].blank?
      filtered_params.delete(:password)
      filtered_params.delete(:password_confirmation)
    end

    # 3. Salvamos usando a variável já limpa!
    if @user.update(filtered_params)
      redirect_to admin_users_path, notice: "Usuário atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # GET /admin/users/:id/audit_logs
  # =========================================================================
  # ESTE É O MÉTODO QUE ESTAVA FALTANDO PARA ALIMENTAR A TELA DE AUDITORIA
  # =========================================================================
  def audit_logs
    authorize [:admin, @user]
    
    # PAPER_TRAIL: Busca a "Caixa Preta" deste usuário, ordenando do mais recente para o mais antigo
    @versions = @user.versions.order(created_at: :desc)
  end

  private

  def set_user
    @user = User.find(params.expect(:id))
  end

  def user_params
    # Adicionamos a permissão profunda para o Profile e o Address
    params.require(:user).permit(
      :email, :password, :password_confirmation, :active, :role, 
      profile_attributes: [
        :id, :first_name, :last_name, :phone, :bio,
        address_attributes: [:id, :zip_code, :street, :number, :complement, :city, :state]
      ]
    )
  end
end