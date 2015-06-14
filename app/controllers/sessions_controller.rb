class SessionsController < ApplicationController
  def new
  	render :layout => "empty"
  end

  def create
  	user = User.find_by(email: params[:session][:email])
  	if user && user.authenticate(params[:session][:password])
  		log_in user
      if (params[:session][:remember_me] == '1')
        remember user
      else
        forget user
      end
  		redirect_to user
  	else
  		flash.now[:danger] = "Invalid email/password combination"
	  	render 'new', :layout => "empty"
	  end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
