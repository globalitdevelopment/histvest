class ApplicationController < ActionController::Base

  protect_from_forgery

  include SessionsHelper
  include ApplicationHelper

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

  def find_frequent_searches
    @max = SearchTopic.where('search_topics.updated_at > ?', 1.months.ago).maximum(:view_count) || 0.0
    @frequent_topics = Topic.published
      .joins("INNER JOIN search_topics ON search_topics.search_string = topics.title")
      .order("CASE WHEN search_topics.view_count / #{@max} >= 0.75 THEN 0
        WHEN search_topics.view_count / #{@max} >= 0.50 THEN 1
        WHEN search_topics.view_count / #{@max} >= 0.25 THEN 2
        ELSE 3
      END")
      .order('search_topics.updated_at')
      .where('search_topics.updated_at > ?', 1.months.ago)
      .limit(10)
      .to_a

    if @frequent_topics.empty?
      @frequent_topics = Topic.published
        .joins("INNER JOIN search_topics ON search_topics.search_string = topics.title")
        .order("search_topics.view_count DESC")
        .limit(10)
        .to_a
    end
  end

end
