class SidebarComponent < ViewComponent::Base
  delegate :icon, to: :helpers

  def initialize(user:)
    @user = user
    @nav_items = NavigationConfig.for(user)
  end
end