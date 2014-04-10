class ArticlesController < ApplicationController
  load_and_authorize_resource :except => :show
  before_filter :authenticate_user!, :except => :show
  # GET /articles
  # GET /articles.json

  def index         
    if params[:article_report] && params[:article_report][:descending] == "false"
      @flag = true
    else
      @flag = false
    end    
    @article_report = ArticleReport.new(params[:article_report])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @article = Article.find(params[:id])
    @frequent_searches = SearchTopic.where('created_at > ?',Time.now - 7.days).limit(10).to_a
    respond_to do |format|
      if @article.published == false
        format.html { redirect_to articles_path, notice: I18n.t("articles.article_not_published")}        
      else
        format.html {render :layout => 'public' } 
        format.json { render json: @article.to_json }
      end
    end
  end

  # GET /articles/new
  # GET /articles/new.json
  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  # POST /articles.json
  def create        
    @article = Article.new(params[:article])    
    @article.published = true
    @article.user_id = current_user.id    

    respond_to do |format|
      if @article.save
        if params[:avatar] && params[:avatar][:avatar_img]
          @avatar = Avatar.create(:avatar_img => params[:avatar][:avatar_img], :article_id => @article.id)                
        end

        if params[:commit] == "Lagre"
          format.html { redirect_to edit_article_path(@article), notice: I18n.t("articles.create_flash") }
          format.json { render json: edit_topic_path(@article), status: :created, location: @article }
        else
          format.html { redirect_to @article, notice: I18n.t("articles.create_flash") }
          format.json { render json: @article, status: :created, location: @article }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.json
  def update
    @article = Article.find(params[:id])
    respond_to do |format|
      if @article.update_attributes(params[:article])
        if params[:avatar] && params[:avatar][:avatar_img]
          @avatar = Avatar.find_by_article_id(@article.id)
          if @avatar
            @avatar.update_attribute(:avatar_img,params[:avatar][:avatar_img])
          else
            @avatar = Avatar.create(:avatar_img => params[:avatar][:avatar_img], :article_id => @article.id)                
          end
        end
        if params[:commit] == "Lagre"
          format.html { redirect_to edit_article_path(@article), notice: I18n.t("articles.create_flash") }
          format.json { render json: edit_topic_path(@article), status: :created, location: @article }
        else
          format.html { redirect_to @article, notice: I18n.t("articles.create_flash") }
          format.json { head :no_content }
        end
      else
        format.html { render action: "edit" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article = Article.find(params[:id])    
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url }
      format.json { head :no_content }
    end
  end
  
  def batch_actions     
    article_ids = params["art_ids"].split(",")
    articles = Article.find_all_by_id(article_ids)
    articles.each do |art|  
      if params["batch_action"] == "delet"  
        art.destroy
      else
        art.update_attribute(:published,params["batch_action"] == "publish" ? true : false)
      end
    end
    flash[:notice] = "#{articles.length} article(s) have been #{params["batch_action"]}ed" 
    redirect_to articles_url    
  end

end

