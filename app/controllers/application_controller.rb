class ApplicationController < ActionController::Base

  protect_from_forgery

  include SessionsHelper

  before_filter :title

  layout 'admin'
 
  rescue_from CanCan::AccessDenied do |exception|
    flash[:danger] = exception.message
    redirect_to url_for(:controller=>:static_pages,:action=>:admin)
  end

  def title(page_title = "")
    if page_title != ""
      @title = page_title + " - " + I18n.t("layouts.public.historiske_vestfold")
    else
      @title = I18n.t("layouts.public.historiske_vestfold")
    end
  end

  private

  def authenticate_user!
    begin
      flash[:danger] = I18n.t('sessions.must_be_logged_in')
      redirect_to(signin_url)
    end unless current_user
  end
end
