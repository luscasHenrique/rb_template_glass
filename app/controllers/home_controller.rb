class HomeController < ApplicationController
  def index
    # Pergunta pro Pundit: Eu posso acessar a ação 'show?' na política 'dashboard'?
    authorize :dashboard, :show?
  end
end
