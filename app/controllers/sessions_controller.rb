class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
  end

  def create
    user = User.find_by username: params[:username]
    
    if !user || !user.authenticate(params[:password])
      redirect_to :back, notice: "Username and/or password mismatch!"
    elsif user.banned
      redirect_to :back, notice: "Your account is frozen, please contact admin!"
    else
      session[:user_id] = user.id
      redirect_to user, notice: "Welcome back!"
    end
  end

  def destroy
    # nollataan sessio
    session[:user_id] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end