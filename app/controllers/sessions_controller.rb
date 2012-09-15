class SessionsController < ApplicationController

  def new
  end

  # POST /sessions
  # POST /sessions.json
  def create
    sign_in_params = params[:session]
    login = sign_in_params[:login]
    password = sign_in_params[:password]
    remember_me = sign_in_params[:remember_me]
    user = User.authenticate_by_username(login, password)

    respond_to do |format|
      if user 
        format.html {
          sign_in_as user
          redirect_to root_url, :notice => "Logged in!"
        }
        format.json { render json: @user, status: :created }
      else
        format.html {
          flash.now.alert = "Invalid Login or Password"
          render action: "new"
        }
        format.json { render json: "errors", status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sessions/1
  # DELETE /sessions/1.json
  def destroy
    sign_out
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

end

