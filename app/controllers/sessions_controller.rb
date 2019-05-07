class SessionsController < Devise::SessionsController
  def create
    binding.pry
    super
    binding.pry
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    binding.pry
    yield resource if block_given?
    respond_with resource do |format|
      format.json { render json: {message: "signed in successfully",url: after_sign_in_path_for(resource)}} 
    end
  end
end
