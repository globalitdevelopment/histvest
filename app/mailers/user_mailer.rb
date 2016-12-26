class UserMailer < ActionMailer::Base
  default from: "Historiske Vestfold <postmaster@histvest.no>"
  
  def get_new_password(user)
    @user = user
    @user_name = @user.name
    @token = @user.reset_token
    email = @user.email 
    mail(:to => email, :subject => I18n.t('emailsubject.subject'))
  end
end
