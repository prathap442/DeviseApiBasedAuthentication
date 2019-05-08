HMACSECRET = "JWTCODIFY"
class SessionsController < Devise::SessionsController
  respond_to :json
  def create
    email = params[:user][:email]
    @user = User.find_by(email: email)
    @password = params[:user][:password]
    if @user.valid_password?(@password)
      payload = {
        id: @user.id,
        expires_at: 5.hours.from_now
      }
      encoded_token = JWT.encode payload, HMACSECRET, 'HS256'
      @user.encoded_token = encoded_token
      @user.save
      render json: {"token": encoded_token}
    end
  end

  def destroy
    user_token = request.headers.env["HTTP_X_AUTH_TOKEN"]
    payload = JWT.decode(user_token,HMACSECRET,'HS256')[0]
    if payload
      @user = User.find(params[:user][:id])
      if(@user.encoded_token == user_token)
        if(payload["expires_at"] < Time.now)
          @user.encoded_token = 0
          @user.save
          render json: {msg: "session Timedout"}
        end
        @user.update(encoded_token: 0)
        render json: {msg: "successfully session destroyed",user: @user.email}
      elsif(@user.encoded_token == "0")
        render json: {msg: "token got expired please sign in"}
      else  
        head :unauthorized
      end
    end
  end

  private
  def respond_to_on_destroy
  end
end