class SessionsController < ApplicationController
  
	def new
    if current_user
      redirect_back_or "/static_pages/admin"
    end
	end

	def create
		user = User.find_by_email(params[:session][:email].downcase)
	  	if user && user.authenticate(params[:session][:password])
        unless user.status
          flash[:danger] = I18n.t('session.status_error', :default => "Your account is blocked temporary, please contact administrator.")   #'Invalid email/password combination'
          redirect_to :action => :new and return
        end

	  		sign_in user
	   		redirect_back_or "/static_pages/admin"
	  	else
	  		flash[:danger] = I18n.t('session.flash_error')   #'Invalid email/password combination'
	  		redirect_to :action => :new
	  	end  
	end

	def destroy
		sign_out
		redirect_to root_url
	end

	def forgot_password
    
  end

  def get_new_password
    @user = params[:session] && User.find_by_email(params[:session][:email].downcase)	  	
  	if @user
      @user.update_attribute :reset_token, SecureRandom.urlsafe_base64
    	UserMailer.get_new_password(@user).deliver	  		
      flash[:success] = I18n.t('sessions.instructions_sent', :default => "Instructions to reset password has been sent to your email")
  		redirect_to signin_path
  	else  		
      flash[:danger] = I18n.t('sessions.email_not_exists', :default => "Email not exists in records.")
  		redirect_to forgot_pass_path
  	end  		  	
  end

  def change_password_form
  	@user = User.find_by_id_and_reset_token(params[:id],params[:token])    
    unless @user
      flash[:danger] = I18n.t('sessions.wrong_token', :default => "Wrong reset password details.")
      redirect_to forgot_pass_path
    end 
  end

  def update_new_password
    @user = User.find_by_id_and_reset_token(params[:id],params[:token])    
    unless @user
      flash[:danger] = I18n.t('sessions.wrong_token', :default => "Wrong reset password details.")
      redirect_to forgot_pass_path
    end      
    
    # quick fix for skip password issue
    @user.password = params[:user][:password].empty? ? "0" : params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation].empty? ? "0" : params[:user][:password_confirmation]

    if @user.save       
      @user.update_attribute :reset_token, nil      
      flash[:succcess] = I18n.t('sessions.password_changed', :default => "Password changed successfully.")
      redirect_to signin_path
    else                  
      render :action => :change_password_form
    end
  end

end
