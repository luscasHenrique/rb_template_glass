# test/test_helper.rb
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)
    fixtures :all

    # 1. Inclui o Devise para permitir o comando sign_in
    include Devise::Test::IntegrationHelpers 
    
    # 2. INCLUA ESTA LINHA: Habilita a sintaxe curta do FactoryBot
    include FactoryBot::Syntax::Methods 
  end
end