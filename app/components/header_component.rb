class HeaderComponent < ViewComponent::Base
  def initialize(title: "Dashboard")
    @title = title.presence || "Dashboard"
  end
end
