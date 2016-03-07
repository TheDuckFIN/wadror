class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
  end

  def create_oauth
    data = env["omniauth.auth"]

    user = User.find_by github_uid: data.uid

    if user.nil?
      newuser = User.create username: data.info.nickname, password: "Github123", password_confirmation: "Github123", github_uid:data.uid
      session[:user_id] = newuser.id
      redirect_to newuser, notice: "Welcome to ratebeer, #{newuser.username}"
    else
      if user.banned?
        redirect_to :back, notice: "Your account is frozen, please contact admin!"
      else
        session[:user_id] = user.id
        redirect_to user, notice: "Welcome back!"
      end
    end
  end

  def create
    user = User.where(username: params[:username], github_uid: nil).limit(1)
    
    if user.empty? || !user.first.authenticate(params[:password])
      redirect_to :back, notice: "Username and/or password mismatch!"
    elsif user.first.banned
      redirect_to :back, notice: "Your account is frozen, please contact admin!"
    else
      session[:user_id] = user.first.id
      redirect_to user.first, notice: "Welcome back!"
    end
  end

  def destroy
    # nollataan sessio
    session[:user_id] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end