class SessionsController < Devise::SessionsController
  def create
    binding.pry
    super
    binding.pry
  end
end
